pragma solidity  >=0.4.21 <0.7.0;

contract couponModify{
 
   
    mapping(address => bool)internal Avaliable;
    mapping(uint => Inventory) public coupons;
    mapping(address => uint) public ownerAccounts;
    mapping(address => bool)internal hasSigned;
  
    uint idcoupon=0;
   // bool signed = false;
    struct Inventory{
        address couponAddress;
        uint value; 
        address payable owner;
    }
    
    Inventory[] internal coupon;
    address[] internal couponAccts;
    
    modifier isSigned(){
        require (hasSigned[msg.sender] == true, "User does not  have an account");
        _;
    }
    
    function setAccount () external {
        require (hasSigned[msg.sender] == false);
        hasSigned[msg.sender] = true;
       
    }
   
   
    function deposit () external payable isSigned {
        ownerAccounts[msg.sender] += msg.value;
    }
    function withdraw () external payable isSigned {
        ownerAccounts[msg.sender] -= msg.value;
        msg.sender.transfer(msg.value);
    }
    
     function addNew(address _couponAddress, uint _val) external isSigned  {
        Inventory storage new_coupon = coupons[idcoupon];
        new_coupon.couponAddress = _couponAddress;
        new_coupon.value = _val;
        new_coupon.owner = msg.sender;
        
        coupon.push(new_coupon);
        Avaliable[coupons[idcoupon].couponAddress]=true;
        idcoupon++;
         
    }
    
    
    function UseCoupon (uint _id) external isSigned {
        require(msg.sender == coupons[_id].owner);
        delete coupons[_id];
            idcoupon--; 
        
    }
    
    function Remove_from_Market (uint _id) external isSigned{
        require(msg.sender == coupons[_id].owner);
        Avaliable[coupons[_id].couponAddress]=false;
    }
    
    function Add_to_Market (uint _id) external isSigned{
        require(msg.sender == coupons[_id].owner);
        Avaliable[coupons[_id].couponAddress]=true;
    }
    
    

    function getInventory ()  external isSigned  {
        
        for(uint i=0; i<idcoupon; i++){
            if (coupons[i].owner == msg.sender){
                couponAccts.push(coupons[i].couponAddress);         
            }    
        }
    }
    
    function showInventory () view external isSigned returns (address[] memory){
              
        return couponAccts;
    }
    
    
    
    function Buy (uint _id) external payable isSigned{
        require(msg.sender != coupons[_id].owner,  "You are Not the owner");
        require(ownerAccounts[msg.sender] >= coupons[_id].value,  "Unsufficient Funds");
        require(Avaliable[coupons[_id].couponAddress]=true, "Not Avaliable for Trade");
        
        
        ownerAccounts[msg.sender] -= coupons[_id].value;
        ownerAccounts[coupons[_id].owner] += coupons[_id].value;
        coupons[_id].owner = msg.sender;
    }
    

    function Trade(uint _mycouponID, uint _wantedcouponID) external payable isSigned{
        
        require(msg.sender == coupons[_mycouponID].owner, "You are Not the owner");
        require(msg.sender != coupons[_wantedcouponID].owner, "This is your coupon");
        require (ownerAccounts[msg.sender] >= msg.value, "Unsufficient Funds");
        require( coupons[_mycouponID].value +  msg.value == coupons[_wantedcouponID].value, "Not enough funds" );
        require(Avaliable[coupons[_mycouponID].couponAddress]=true, "Not Avaliable for Trade");
        require(Avaliable[coupons[_wantedcouponID].couponAddress]=true, " Not Avaliable for Trade");
        
        ownerAccounts[msg.sender] -= msg.value;
        ownerAccounts[coupons[_wantedcouponID].owner] += msg.value;
        
        coupons[_mycouponID].owner = coupons[_wantedcouponID].owner;
        coupons[_wantedcouponID].owner = msg.sender;
    }
    
    
    
}
   

