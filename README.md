# QuillHash Security Transfer Offering 



## Overview


The QH20 is ERC20 Smart contract that serves multiple purposes for STO platform, support re-deployment of regulation service contract to change regulation also Kyc/Aml is done using smart contract, there are multiple parameters that can be used for KYC out of that email Id, phone no verification, Social media account verification is adopted for current scenario there are multiple levels according to which service regulation can be enforced. Smart contract also enable transparent and decentralised voting system only for valid Investors.


## Features :

```
1) Security Tokens Offering(STO).

2) ERC20 based Smart contract.

3) Regulatory Smart Contract.

4) Transfer and transferfrom function call verify() of regulation contract to enforce regulation.

5) Dividend Distribution.

6) Voting Through Smart Contracts.

7) KYC through Smart Contracts(manual kyc, Email verification, Phone number Verification, Social Media verification,(manual verification is compulsory)).

8) Force Transfer by Owner only.

9) Regulatory Contract can be replaced any time by Owner, if Regulation of your country will get modified you can redeploy regulatory contract with checksum you can modify according to that.

10) Voting System is Decentralised and transparent.
```


## Contracts in QuillSTO Platform

```
Contract : QuillSTO (Token Contract )
Contract : Crowdsale (Smart Contract for Crowdsale )
Contract : Regulator Services(Smart Contracts to enforce Regulation )
Contract : Voting Factory Smart Contract (Smart contract for generating Voting contract )
Contract : Voting Contract (generated from factory contract as a separate entity for every new  voting agenda)
Contract : ValidateBeneficiary (This contract serves as a kyc contract for whitelisted Investors)
```

## QuillSTO Smart Contract

QuillSTO smart contract is a Token Contract that serves the basic functionalities of a token contract including dividend based distribution, everytime new voting agenda is introduced, voting will be initiated only after activating that Voting Contract, regulation service contract can be re deployed to change enforced regulation by re-setting regulation address which will be called during transfer.

## CrowdSale Smart Contract

Crowdsale smart contract of STO platform provide functionality to participate in a crowdsale as a investor, only whitelisted Investor will be able to participate.

## Regulator Services Smart Contract

To enforce regulation while transferring tokens this contracts check whether investor will be able to transfer their assets to another according to current regulation these regulations can be modified any time and re-deployed to main net, this contract will call validatebeneficiary contract that serve as a KYC contract and take action accordingly.

## Validate Beneficiary Smart Contract

Validate beneficiary smart contract is serve as KYC contract, after manually verifying  email id, phone no, social media account, validated investors will be able to transfer their assets on the bases of their KYC status.

## Voting Factory Smart contract

Voting factory contract will produce new voting smart contract everytime voting is required. 

## Voting Smart contract

All voting will be done through smart contract owner will be able to start voting only after token contract will give permission to voting contract produced from factory smart contract.


# Steps to Deploy Smart contracts:


1) Deploy Regulation Service smart contract that doesn’t require any parameter. 

2) Deploy Quill STO smart contract that require two parameter :
   Address of a owner. 
   Address of regulation service contract. 

3) Deploy Crowdsale contract that require four parameters :
   address of a owner,
   address of token contract
   address of a wallet
   ether price in cents 

4) Deploy Voting Factory Contract that doesn’t require any parameter.

5) Deploy validate Beneficiary contract that doesn’t require any parameter.


## Steps to participate in Crowdsale and use other functions in STO platform


1) Activate Crowdsale contract by calling function ```activateCrowdsale()``` that require one parameter, address of a Crowdsale     contract this function will not start the crowdsale, will only initialised the require tokens to crowdsale contract.

2) To participate in a crowdsale investor must be whitelisted, that means it’s ethereum address must be whitelisted before participating in a crowdsale. That can be done by calling function ```authorisedKyc()``` , Owner can whitelist multiple investor at a time. you can check whitelisted investor by calling ```whitelistedContributers()``` that require one parameter address of investor.
 
3) Start crowdsale by calling function ```startCrowdSale()``` this will start crowdsale and whitelisted contributors can participate in crowdsale.

4) Call function ```buyToken()``` of crowdsale contract that require one parameter address of a investor. This is a payable function investor need to set ether amount, investor will get the sufficient tokens according to token price and amount of ether they send to contract. Investors balance will be reflected in their wallet as well as they can check their token balance by calling balance of token contract that required address of a beneficiary.

5) End Crowdsale by calling function ```endCrowdSale()``` that doesn’t require any parameter only Owner can end crowdsale. This function also call ```finalize()``` of a token contract that change the state condition of fundraising variable to false and inform token contract that sale is over afterwards dividend can be received from dividend address and will be distributed to all investor.

6) Set Dividend address by calling function ```setDividendAddress()``` that require one parameter, address of dividend sender. Only this address is allowed  to send ether to token contract and will be stored in token contract to distribute dividend call function ```distributeDividend()``` that can be only called by owner of token contract and will be able to distribute dividend equally to all Investors.

7) ```freezeAccount()``` this function will freeze the investors account and investor of a beneficiary will not be able to transfer tokens also will not be able to participate in a crowdsale. 

8) ```Setvalidatebeneficiary()``` contract address to Regulation service contract that require one parameter, address of a validate beneficiary contract, this function will only be call by owner of a contract.

9) Set crowdsale contract address to validate beneficiary contract by calling function set CrowdsaleAddress() that require one parameter address of crowdsale contract and this function will be only call by owner of a contract.

10) ```isKycValid()``` function of validate beneficiary contract will check if kyc is done for investor during crowdsale, ```validatedEmailIds()```, ```validatedPhoneNo()```, ```validatedSocialAccount()``` all three function can accept multiple address of a investors, by manually validating KYC documents for investors you can call these functions to enforce regulations on the basis of number, verify function of Regulation contract will get by calling ```checkKycStatus()```. 
```checkKycStatus()``` will return a kyc number according to the regulation verify function, regulation will allow for transfer, each number have it’s own significance.  

11) Set token and Crowdsale contract address to voting factory contract, that required address of token contract and Crowdsale contract respectively. Call function ```createVotingContract()``` to create separate voting contract each time voting is required this function requires two parameter _VotingContractId  _agendaOfVoting you will get the address of new voting contract by calling ```VotingContractIdIdVsVotingContract()``` that require voting id and will return address of voting contract. You can deploy voting contract by simply getting address of a voting contract by voting id.

12) Voting will be start only, after voting contract will activated by owner of token contract by calling function ```activateVotingContract()``` that require one parameter address of voting contract. 

13) Call function ```startVoting()```  of voting contract to start voting, this function will only be called by owner of a contract, to participate in voting call ```participateInVoting()```  that require one parameter _votingValue voting value can be either one of two, one for vote in favour and two for vote against. Only whitelisted investor will be able to participate in voting,all the voting stats are easy to get from getter functions in voting contract, to end voting call function ```endVoting()```  that can be call by owner of the contract.

14) ```verify()``` of regulation contract is very important function to enforce regulation to transfer tokens, you can change the regulation difficulty accordingly and you can also re-deploy regulation smart contract and re-set to token contract. 

15) ```forceTransfer()``` enable owner to forcely tranfer tokens from one account to another account this function will only be call by owner of a token contract and require three parameters address sender, address receiver, token amount. 


 



       



  
