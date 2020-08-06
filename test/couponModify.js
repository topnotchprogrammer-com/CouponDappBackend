const couponModify = artifacts.require('couponModify');

contract('couponModify', () => {
    it('Should set an Account', async ()=> {
        const couponModify = await couponModify.deployed();
        await couponModify.setAccount()
    })
});