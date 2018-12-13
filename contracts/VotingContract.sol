pragma solidity 0.4.24;
import "./SafeMath.sol";
import "./Ownable.sol";

contract Crowdsale {
  function islisted(address _beneficiary) public view returns (bool);
}

contract QuillSTO {
  function balanceOf(address _beneficiary) public view returns (uint256);
  function isFreezeAccount(address _investor) public view returns(bool);
  function isVotingContractActive(address _votingContract) public view returns (bool);
}

contract VotingContract is Ownable{
    
    using SafeMath for uint256;

    address public tokenContract;  
    address public CrowdsaleContract;
    address[] public participatedInVoting;
    address[] public participatedInVotingFavour;
    address[] public participatedInVotingAgainst;
    uint256 public voteCountFavour;
    uint256 public voteCountAgainst;
    uint256 public VotingContractId;
    string public agendaOfVoting;
    
    enum votingStatus {notStarted,pause,running,end}
    votingStatus currentStage;
    
    mapping(address => uint256) voteOfInvestor;
    
    constructor(uint256 _VotingContractId,string _agendaOfVoting,address _owner,address _tokenContract,address _crowdSaleContract) public Ownable(_owner) {
        currentStage = votingStatus.notStarted;
        VotingContractId = _VotingContractId;
        agendaOfVoting = _agendaOfVoting;
        owner = _owner;
        tokenContract = _tokenContract;
        _crowdSaleContract = _crowdSaleContract;
  
    }
    
    function startVoting() public onlyOwner
    {
    
        require(QuillSTO(tokenContract).isVotingContractActive(address(this))==true);
        require(currentStage == votingStatus.notStarted);
        currentStage = votingStatus.running;
        voteCountFavour = 0;
        voteCountAgainst = 0;
    }
    
    function endVoting() public onlyOwner  
    {
        require(currentStage == votingStatus.running);
        currentStage = votingStatus.end;

    }

    function participateInVoting(uint256 _voteValue) public isparticipateListed {
    
     require(CrowdsaleContract != 0x0);
     require(tokenContract != 0x0);
     require(QuillSTO(tokenContract).isFreezeAccount(msg.sender)==false);
     
       if(_voteValue == 1)
       
       {
          participatedInVoting.push(msg.sender);
          participatedInVotingFavour.push(msg.sender);
          voteOfInvestor[msg.sender] = _voteValue;
          voteCountFavour = voteCountFavour.add(1); 
       }    
       
       else if (_voteValue == 2)
       
       {
          participatedInVoting.push(msg.sender);
          participatedInVotingAgainst.push(msg.sender);
          voteOfInvestor[msg.sender] = _voteValue;
          voteCountAgainst = voteCountAgainst.add(1);
       }
       else {
           revert();
       }
    }
    
    function checkKYC(address _voter) internal view returns(bool) 
    {
        require(CrowdsaleContract != 0x0,"Crowdsale Contract is null");
        return Crowdsale(CrowdsaleContract).islisted(_voter);
    }
    
    modifier isparticipateListed(){
        
    
    require(checkKYC(msg.sender));
    

        _;

    }
    
    function totalParticipantsInVoting() public view returns(uint256) {
        return voteCountAgainst.add(voteCountFavour);
    }
    
    function displayVoteCountFavour() public view returns(uint256) {
        return voteCountFavour;
    }
    
    function displayVoteCountagainst() public view returns(uint256) {
        return voteCountAgainst;
    }
    
    function participatedInFavour() public view returns(address[]) {
        return participatedInVotingFavour;
    }
    
    function participatedAgainst() public view returns(address[]) {
        return participatedInVotingAgainst;
    }

    
}