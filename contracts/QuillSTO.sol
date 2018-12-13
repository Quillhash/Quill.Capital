pragma solidity ^0.4.24;

import './StandardToken.sol';
import './Ownable.sol';
import './Pausable.sol';

contract RegulatorService{
    function verify(address _token, address _spender, address _from, address _to, uint256 _amount) public view returns (uint256);
}
contract VotingFactoryContract{
 function isVotingAddressCorrect(address _votingContractAddress) public view returns(bool);   
}

contract QuillSTO is StandardToken, Ownable, Pausable
{
    
  string public constant name = "QuillSTO";
  string public constant symbol = "QuillSTO";
  uint32 public constant decimals = 18;    
  uint256 public totalReleased;
  uint256 public totalSupply = uint256(1000000000).mul(1 ether); //Total STO Tokens
  mapping (address => bool) freezedAccounts;
  bool public fundraising = true;
  address public regulator;
  address public saleContract;
  address public dividendAddress;
  address public votingFactoryContractAddress;
  address [] public votingContract;
  address [] public dividendBeneficiary;
  uint256 public dividendValue;
  mapping (address => bool) votingAddressStatus;
  mapping (address => uint256) public dividendRecived;

  
  event SaleContractActivation(address saleContract, uint256 tokensForSale);
    /**
   * @notice Event triggered when `RegulatorService` contract is replaced
   */
    event ReplaceRegulator(address oldRegulator, address newRegulator);
  
    // modifier
    modifier notRestricted (address _from, address _to, uint256 _value) {
        uint256 restrictionCode = RegulatorService(regulator).verify(this, msg.sender, _from, _to, _value);
        require(restrictionCode == 1234);
        
        _;
    }
     /**
   * @dev Validate contract address
   * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114
   * @param _addr The address of a smart contract
   */
    modifier isContract (address _addr) {
        uint length;
        assembly { length := extcodesize(_addr) }
        require(length > 0);
        _;
    }

  constructor(address _newOwner,address _regulator) public Ownable(msg.sender)
  {
    require(_newOwner != address(0));
    require(_regulator != address(0));
    totalReleased = 0; 
    regulator = _regulator;
      
  }

  function activateSaleContract(address _saleContract) public whenNotPaused onlyOwner //transfer sale tokens to crowdsale contract
  
  {
    require(_saleContract != address(0));
    saleContract = _saleContract;
    balances[saleContract] = balances[saleContract].add(totalSupply);
    totalReleased = totalReleased.add(totalSupply);
    require(totalReleased <= totalSupply);
    emit Transfer(address(this), saleContract, totalSupply);
    emit SaleContractActivation(saleContract, totalSupply);
  }
  
  function transfer(address _to, uint256 _value) notRestricted(msg.sender, _to, _value) whenNotPaused public returns (bool) {
    
        return super.transfer(_to, _value);
    }

  function transferFrom(address _from, address _to, uint256 _value) notRestricted(_from, _to, _value) whenNotPaused public  returns (bool) {

    return super.transferFrom(_from, _to, _value);
    
  }

  function approve(address _spender, uint256 _value) public  returns (bool) {
    return super.approve(_spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) public  returns (bool success) {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
    return super.decreaseApproval(_spender, _subtractedValue);
  }

  function saleTransfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
   
    require(saleContract != address(0));
    require(msg.sender == saleContract);
    dividendBeneficiary.push(_to);
    return super.transfer(_to, _value);
  }
  
  function replaceRegulator(address _regulator) public onlyOwner isContract(_regulator){
        
    address oldRegulator = regulator;
    regulator = _regulator;
    emit ReplaceRegulator(oldRegulator, regulator);
        
    }
    
  function _forceTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
    require(_value <= balances[_from]);
    require(_to != address(0));

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(_from, _to, _value);
    return true;
    }

    function forceTransfer(address _from, address _to, uint256 _value)
    public
    onlyOwner
    whenNotPaused
    returns (bool)
    {
        return _forceTransfer(_from, _to, _value);
    }
    /**
    * @dev this function will closes the sale ,after this anyone can transfer their tokens to others.
    */
    function finalize() public whenNotPaused returns(bool) {
        require(fundraising != false);
        require(msg.sender == saleContract);
        fundraising = false;
        return true;
    }

    
    function freezeAccount(address _investor) public onlyOwner 
    {
         freezedAccounts[_investor] = true;
    }    
    
    function isFreezeAccount(address _investor) public view returns(bool) 
    {
         return freezedAccounts[_investor];
    }
    
    function setDividendAddress(address _dividend) public onlyOwner 
    {
        dividendAddress = _dividend;
    }
    
    function distributeDividend() public onlyOwner {
        require(dividendValue>0);
        for(uint256 i = 0; i<dividendBeneficiary.length; i++ ){
            dividendRecived[dividendBeneficiary[i]] = dividendRecived[dividendBeneficiary[i]].add(dividendValue.div(dividendBeneficiary.length));
            dividendBeneficiary[i].transfer(dividendValue.div(dividendBeneficiary.length));
            
        }
    }
    
    function activateVotingContract(address _votingContract) public onlyOwner isContract(_votingContract) returns (bool){
     
     require(votingFactoryContractAddress != address(0));
     require(_votingContract != address(0));
     votingContract.push(_votingContract);    
     require(VotingFactoryContract(votingFactoryContractAddress).isVotingAddressCorrect(_votingContract));
    }
    
    function isVotingContractActive(address _votingContract) public view returns (bool){
        return votingAddressStatus[_votingContract];
    }
    
    function () public payable {
        require(!fundraising);
        if(msg.sender == dividendAddress){
          
            dividendValue = msg.value;
        }
    
    else {
         revert();
        }
   }
  


}
