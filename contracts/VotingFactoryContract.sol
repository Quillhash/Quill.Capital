pragma solidity 0.4.24;
import "./SafeMath.sol";
import "./Ownable.sol";
import "./VotingContract.sol";

contract VotingFactoryContract is Ownable{
    
    mapping(uint256 => address) VotingContractIdIdVsVotingContract;
    mapping(uint256 => string) VotingContractIdIdVsVotingAgenda;
    mapping(uint256 => bool) VotingContractIDs;
    mapping(address => bool ) votingContractStatus;
    address public tokenContract;  
    address public CrowdsaleContract;
     
    
    constructor() Ownable(msg.sender) public {}
    
    function setTokenAddress(address _tokenAddress) public onlyOwner {
        tokenContract = _tokenAddress;
    }
    
    function setCrowdsaleAddress(address _CrowdsaleContract) public onlyOwner {
        CrowdsaleContract = _CrowdsaleContract;
    }

    
    function createVotingContract(uint256 _VotingContractId,string _agendaOfVoting) public onlyOwner returns (address){

      require(VotingContractIDs[_VotingContractId]==false);
      
      address _VotingContract = new  VotingContract(_VotingContractId,_agendaOfVoting,msg.sender,tokenContract,CrowdsaleContract);  
      
      VotingContractIdIdVsVotingContract[_VotingContractId] = _VotingContract;
      VotingContractIdIdVsVotingAgenda[_VotingContractId] = _agendaOfVoting;
      VotingContractIDs[_VotingContractId]=true;
      votingContractStatus[_VotingContract]=true;
      return _VotingContract;         
    }
    
    function VotingContractAddressById(uint256 _VotingContractId) public view returns(address){
         return VotingContractIdIdVsVotingContract[_VotingContractId];
    }
    
    function VotingAgendaById(uint256 _VotingContractId) public view returns(string){
         return VotingContractIdIdVsVotingAgenda[_VotingContractId];
    }
    
    function isVotingAddressCorrect(address _votingContractAddress) public view returns(bool){
        return votingContractStatus[_votingContractAddress];
    }

}