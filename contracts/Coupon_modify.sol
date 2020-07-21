pragma solidity  >=0.4.21 <0.7.0;

contract couponModify{
 
   
    /*mapping(address => bool)internal hasSigned;
    mapping(address => bool)internal hasApprove;
    mapping(address => bool) internal hasRemove;
    mapping(address => bool) internal hasDivorce;
    */
    
    mapping(uint => Inventory) public coupons;
  
    
    uint private iddel;  
    uint idcoupon=0;

    /*
    struct Inventory{
        address couponAddress;
        uint value; 
        address owner;
    }
    */
     struct Inventory{
        uint couponAddress;
        uint value; 
        address owner;
    }
        
    Inventory[] internal coupon;
    
    //address[] public couponAccts;
    
    uint[] public couponAccts;
   
   
    
   /* function addNew(address _couponAddress, uint _val) public {
        
        Inventory storage new_coupon = coupons[idcoupon];
        
        new_coupon.couponAddress = _couponAddress;
        new_coupon.value = _val;
        new_coupon.owner = msg.sender;
        
        coupon.push(new_coupon);
        
        idcoupon++;
         
    }  
    */
     function addNew(uint _couponAddress, uint _val) public {
        Inventory storage new_coupon = coupons[idcoupon];
        new_coupon.couponAddress = _couponAddress;
        new_coupon.value = _val;
        new_coupon.owner = msg.sender;
        
        coupon.push(new_coupon);
        
        idcoupon++;
         
    }
    
    
    function deleteCoupon (uint _id) external {
        require(msg.sender == coupons[_id].owner);
        iddel = _id;
        delete coupons[iddel];
            idcoupon--; 
        
    }
    
  /*  function getOwner(address _couponAddress) view public returns (address){
        for(uint i=0; i<idcoupon; i++){
            if (coupons[i].couponAddress == _couponAddress){
                return (coupons[i].owner);            
            }
        }
    }
    */
    
    
    function getInventory ()  public  {
        
        for(uint i=0; i<idcoupon; i++){
            if (coupons[i].owner == msg.sender){
                couponAccts.push(coupons[i].couponAddress);         
            }    
        }
    }
    
   /* function clearInventory () public{
        couponAccts
    }*/
    /*
    function showInventory () view public returns (address[] memory){
        return couponAccts;
    } */
    function showInventory () view public returns (uint[] memory){
        return couponAccts;
    }
    
    function Sell (uint _couponAddress) public{
        
        
        
    }
    
}
   

