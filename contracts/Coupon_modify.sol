pragma solidity ^0.7.0;

contract couponModify{
 
   
    mapping(address => bool)internal Avaliable;
    mapping(uint => Inventory) public coupons;
    mapping(address => uint) public ownerAccounts;
    mapping(address => bool)internal hasSigned;
    mapping(string => Inventory) public Searched_Coupons;
    uint idcoupon=0;
    
    struct Inventory{
        address couponAddress;
        uint value;                 //price of coupon 
        address payable owner;
        string keyword;
    }
    
    
    Inventory[] internal coupon;
    address[] internal couponAccts;
    //address[] internal Searched_Coupons;
    
    modifier isSigned(){
        require (hasSigned[msg.sender] == true, "User does not  have an account");
        _;
    }
    
    function setAccount () external {
        require (hasSigned[msg.sender] == false, "You already have an account!");
        hasSigned[msg.sender] = true;
       
    }
   
   function checkAccount () view external returns (bool){
        require (hasSigned[msg.sender] == true, "You don't have an account.");
        return(hasSigned[msg.sender]);
       
   }
   
    function deposit () external payable isSigned {
        ownerAccounts[msg.sender] += msg.value;
    }
    function withdraw () external payable isSigned {
        ownerAccounts[msg.sender] -= msg.value;
        msg.sender.transfer(msg.value);
    }
    
     function addNew(address _couponAddress, string calldata _keyword) external isSigned  {
        Inventory storage new_coupon = coupons[idcoupon];
        new_coupon.couponAddress = _couponAddress;
        new_coupon.value = 0;
        new_coupon.owner = msg.sender;
        new_coupon.keyword = _keyword;
        
        coupon.push(new_coupon);
        Avaliable[coupons[idcoupon].couponAddress]=false;
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
    
    function Add_to_Market (uint _id) external payable isSigned{
        require(msg.sender == coupons[_id].owner);
        coupons[_id].value = msg.value;
        Avaliable[coupons[_id].couponAddress]=true;
        
    }
    
    /*function Search() internal isSigned{
        uint _id;
        Inventory storage new_search = Searched_Coupons[_id];
        for(uint i=0; i<idcoupon; i++){
            if (Avaliable[coupons[i].couponAddress] == true){
                Searched_Coupons.push(coupons[i].couponAddress);         
            }    
        }
        
    }*/
    
    

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
    
   /* function Search(string calldata _keyword) external isSigned {
        string storage _key = _keyword;
        for(uint i=0; i<idcoupon; i++){
               
            if(coupons[i].keyword ==_key){
                
            }
        }
        
    }*/
    
    
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
   

