pragma solidity ^0.4.24;
import './Ownable.sol';


contract ValidateBeneficiary{
    
    function checkKycStatus(address _beneficiary) public view returns(uint256);    
}

contract RegulatorService is Ownable {

   address public KycContractAddress;
   constructor() public Ownable(msg.sender){}
   /**
   * @notice This method is called by `AtomicToken` during `transfer()` and `transferFrom()`
   *         The implementation should contain all restrictions logic on tranfer of tokens
   * @param  _token The address of the token to be transfered
   * @param  _spender The address of the spender of the token
   * @param  _from The address of the sender account
   * @param  _to The address of the receiver account
   * @param  _amount The quantity of the token to trade
   * @return Bytecode that signifies approval or reason for restriction; hex"01" means successful transfer
   *         All other values are left to the implementer to assign meanings
   */
    
   function verify(address _token, address _spender, address _from, address _to, uint256 _amount) public view returns (uint256) 
   {
        if(ValidateBeneficiary(KycContractAddress).checkKycStatus(_to)==10){return 1234;}
        else if(ValidateBeneficiary(KycContractAddress).checkKycStatus(_to)==8){return 134;}
        else if(ValidateBeneficiary(KycContractAddress).checkKycStatus(_to)==7){return 124;}
        else if(ValidateBeneficiary(KycContractAddress).checkKycStatus(_to)==6){return 123;}
        else if(ValidateBeneficiary(KycContractAddress).checkKycStatus(_to)==5){return 14;}
        else if(ValidateBeneficiary(KycContractAddress).checkKycStatus(_to)==4){return 13;}
        else if(ValidateBeneficiary(KycContractAddress).checkKycStatus(_to)==3){return 12;}
        else if(ValidateBeneficiary(KycContractAddress).checkKycStatus(_to)==0){return 0;}
        
   }


   /**
    * @notice This method returns a human-readable message for a given bytecode
    * @dev Implementer must assign custom codes for each restriction reason
    * @param restrictionCode uint256 identifier for looking up message
    * @return Text with reason for restriction 
    */
    
    function restrictionMessage(uint256 restrictionCode) public view returns (string)
    {
        if(restrictionCode == 1234) {
            return "All KYC process is done";
        }
        else {
            return "All kYC Not Done";
        }
    }
    
    function KycContract(address _KycContractAddress) public onlyOwner
    {
        KycContractAddress = _KycContractAddress;
    }

    
    

}