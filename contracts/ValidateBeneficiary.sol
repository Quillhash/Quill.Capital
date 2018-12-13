pragma solidity ^0.4.24;
import './Ownable.sol';

//1 kyc through crowdsale contract
//2-email verified 
//3-social media verified
//4-phone no verified(//true caller based for testing)

contract Crowdsale {
    
  function islisted(address _beneficiary) public view returns (bool);
}


contract ValidateBeneficiary is Ownable(msg.sender) {

    
    address public CrowdsaleContract;
    mapping(address => uint256) verifiedbyEmail;
    mapping(address => uint256) verifiedbyPhoneNo;
    mapping(address => uint256) verifiedbySocialAccount;
    
    modifier isparticipateListed()
    {
         require(checkKYC(msg.sender));
        _;

    }

    function CrowdsaleAddress(address _CrowdsaleContract) public 
    {
        CrowdsaleContract = _CrowdsaleContract;
    }
    
    
    function checkKYC(address _spender) internal view returns(bool) 
    {
        require(CrowdsaleContract != 0x0,"Crowdsale Contract is null");
        return Crowdsale(CrowdsaleContract).islisted(_spender);
    }
    
    function validatedEmailIds(address[] addrs) public onlyOwner returns (bool success) {
        
        uint arrayLength = addrs.length;
        
        for (uint x = 0; x < arrayLength; x++) 
        {
            verifiedbyEmail[addrs[x]] = 2;
        }

        return true;
    }
    
    function validatedPhoneNo(address[] addrs) public onlyOwner returns (bool success) {
        
        uint arrayLength = addrs.length;
        
        for (uint x = 0; x < arrayLength; x++) 
        {
            verifiedbyPhoneNo[addrs[x]] = 4;
        }

        return true;
    }
    
    function validatedSocialAccount(address[] addrs) public onlyOwner returns (bool success) {
        
        uint arrayLength = addrs.length;
        
        for (uint x = 0; x < arrayLength; x++) 
        {
            verifiedbySocialAccount[addrs[x]] = 3;
        }

        return true;
    }
    
    function isPhoneNoValid(address _beneficiary) public view returns(uint256){
    
        return verifiedbyPhoneNo[_beneficiary];
    
        
    }
    
    function isEmailValid(address _beneficiary) public view returns(uint256){
        
        return verifiedbyEmail[_beneficiary];
    
        
    }

    function isSocialAccountValid(address _beneficiary) public view returns(uint256){
        
        return verifiedbySocialAccount[_beneficiary];
    
        
    }

    function isKycValid(address _beneficiary) public view returns(uint256){
        
        if(checkKYC(_beneficiary)==true)
        {
            return 1;
        }
        
    }
    //isKycValid is mandatrory for verification
    //rest are optional and can be set according to requirement
    function checkKycStatus(address _beneficiary) public view returns(uint256){
        uint256 KycValue;
        
        if(isKycValid(_beneficiary)==1 && isEmailValid(_beneficiary)==2 && isSocialAccountValid(_beneficiary)==3 && isPhoneNoValid(_beneficiary)==4){return KycValue = 10;}
        else if(isKycValid(_beneficiary)==1 && isSocialAccountValid(_beneficiary)==3 && isPhoneNoValid(_beneficiary)==4){return KycValue = 8;}
        else if(isKycValid(_beneficiary)==1 && isEmailValid(_beneficiary)==2 && isPhoneNoValid(_beneficiary)==4){return KycValue = 7;}
        else if(isKycValid(_beneficiary)==1 && isEmailValid(_beneficiary)==2 && isSocialAccountValid(_beneficiary)==3){return KycValue = 6;}        
        else if(isKycValid(_beneficiary)==1 && isPhoneNoValid(_beneficiary)==4){return KycValue = 5;}
        else if(isKycValid(_beneficiary)==1 && isSocialAccountValid(_beneficiary)==3){return KycValue = 4;}        
        else if(isKycValid(_beneficiary)==1 && isEmailValid(_beneficiary)==2 ){return KycValue = 3;}
        
        
        else { return 0;} 
    }

    



    

}