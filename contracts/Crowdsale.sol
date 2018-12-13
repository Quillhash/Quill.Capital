pragma solidity 0.4.24;
import './SafeMath.sol';
import './Ownable.sol';


contract QuillSTO {

  function saleTransfer(address _to, uint256 _value) public returns (bool);
  function finalize() public returns(bool);

}



/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
 * the methods to add functionality. Consider using 'super' where appropiate to concatenate
 * behavior.
 */


contract Crowdsale is Ownable(msg.sender)  {
  
  using SafeMath for uint256;

  // The token being sold
  QuillSTO public token;

  // Address where funds are collected
  address public wallet;

  // Amount of wei raised
  uint256 public weiRaised;
  // Amount of usd in cents Raised
  
  uint256 public RaisedInCents;
  
  
  mapping (address => bool) public whitelistedContributors;
  mapping(address => uint256) public beneficiaryVsTokens;
  mapping(address => uint256) public beneficiaryVsWeiamount;
 

 
  //Hardcap and softcap of a sale is define
  uint256 public hardCap = 700000000;// 7 mn USD
  
  
  
  //No of tokens sold in each phase
  uint256 public crowdsaleTokenSold=0;
  
  uint256 public ethPrice;
  
  bool public crowdsalestarted = false;
 
  uint256 public crowdsalestartTime;
  uint256 public crowdsaleEndTime;
  
  
  //percentage of bonus in different phases
  
  
  
  uint256 public tokenPrice = 40 * 1 ether; // 

  /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  
  /**
   * @param _wallet Address where collected funds will be forwarded to
   * @param _wallet Address to collect funds
   * @param _token Address of the token being sold
   */
  constructor(address _newOwner, address _wallet, QuillSTO _token, uint256 _ethPriceincents) public 
  {
    require(_wallet != address(0));
    require(_newOwner != address(0));
    require(_token != address(0));
    

    wallet = _wallet;
    owner = _newOwner;
    token = _token;
    ethPrice = _ethPriceincents;

    
  }
  
    function authorizeKyc(address[] addrs) external onlyOwner returns (bool success) {
        uint arrayLength = addrs.length;
        for (uint x = 0; x < arrayLength; x++) {
            whitelistedContributors[addrs[x]] = true;
        }

        return true;
    }

  
    function startCrowdSale() public onlyOwner {
      
      require(!crowdsalestarted);
      crowdsalestarted = true;
      crowdsalestartTime = now;
      
      
    }  
  
    function endCrowdSale() public onlyOwner {
      
      require(crowdsalestarted);
      crowdsalestarted = false;
      crowdsaleEndTime =now;
      require(token.finalize());
      
      
    }  

  
  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    if(msg.sender != owner)
    {
        buyTokens(msg.sender);
    }
    else
    {
        revert();
    }
  }

  /**
   * @param _beneficiary Address performing the token purchase
   */
  function buyTokens(address _beneficiary) public payable {
  
    uint256 weiAmount =msg.value;
    require(weiAmount > 0);
    require(ethPrice > 0);
    require(whitelistedContributors[_beneficiary] == true);
    require(crowdsalestarted == true);
    uint256 usdCents = weiAmount.mul(ethPrice).div(1 ether); 
    
    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(usdCents);
   _preValidatePurchase(_beneficiary, usdCents);
    

    // update state
    weiRaised = weiRaised.add(weiAmount);
    
    beneficiaryVsTokens[_beneficiary] = beneficiaryVsTokens[_beneficiary].add(tokens);
    
    beneficiaryVsWeiamount[_beneficiary] = beneficiaryVsWeiamount[_beneficiary].add(weiAmount);
    
  
    _processPurchase(_beneficiary, tokens);
    
    emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
    
    wallet.transfer(msg.value);
  }
  
  function _getTokenAmount(uint256 _usdCents) public view returns (uint256) {
    
    uint256 tokens = _usdCents.div(100).mul(tokenPrice);
    return tokens;
  }

  /**
   * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
   * @param _beneficiary Address performing the token purchase
 
   */
  function _preValidatePurchase(address _beneficiary, uint256 _usdCents) internal view returns(bool)
  {
    require(_beneficiary != address(0));
    
    RaisedInCents.add(_usdCents);
    
    require(hardCap > RaisedInCents);
    
    return true;
  }
  
  /**
   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
   * @param _beneficiary Address receiving the tokens
   * @param _tokenAmount Number of tokens to be purchased
   */
  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal returns(bool) {
    _deliverTokens(_beneficiary, _tokenAmount);
    return true;
  }

  /**
   * @param _usdCents Value in usd cents to be converted into tokens
   * @return Number of tokens that can be purchased with the specified _usdCents
   */
  
  /**
   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
   * @param _beneficiary Address performing the token purchase
   * @param _tokenAmount Number of tokens to be emitted
   */
  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    require(token.saleTransfer(_beneficiary, _tokenAmount));
  }


  function islisted(address _beneficiary) public view returns (bool){
      return whitelistedContributors[_beneficiary];
  }
  
}
