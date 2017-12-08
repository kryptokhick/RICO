pragma solidity ^0.4.18;
import "../PoD.sol";

/// @title SimplePoD - SimplePoD contract
/// @author - Yusaku Senga - <senga@dri.network>
/// license let's see in LICENSE

contract SimplePoD is PoD {

  function SimplePoD() public {
    name = "KaitsukePoD strategy token price = capToken/capWei";
    version = "0.1";
    period = 7 days;
    podType = 111;
  }

  function setConfig(uint256 _capOfToken, uint256 _capOfWei) public onlyOwner() returns (bool) {
    require(status == Status.PoDDeployed);
    proofOfDonationCapOfToken = _capOfToken;
    proofOfDonationCapOfWei = _capOfWei;
    return true;
  }

  function processDonate(address _user) internal returns (bool) {

    tokenPrice = proofOfDonationCapOfToken / proofOfDonationCapOfWei;

    uint256 remains = proofOfDonationCapOfWei.sub(totalReceivedWei);

    require(msg.value <= remains);

    tokenPrice = proofOfDonationCapOfToken / proofOfDonationCapOfWei;
    
    weiBalances[_user] = weiBalances[_user].add(msg.value);

    if (msg.value == remains)
      return false;
    
    return true;
  }


  function getBalanceOfToken(address _user) public constant returns (uint256) {
    
    return weiBalances[_user].div(tokenPrice);
  }
}