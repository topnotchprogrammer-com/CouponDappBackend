const coupon_modify = artifacts.require('coupon_modify');

contract('coupon_modify', () => {
    it('Should set an Account', async ()=> {
        const coupon_modify = await coupon_modify.deployed();
        await coupon_modify.setAccount()
    })
});