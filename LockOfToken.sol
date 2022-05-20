 SPDX-License-Identifier GPL-3.0

pragma solidity =0.7.0 0.9.0;

interface IERC20 {
    function balanceOf(address owner) external view returns (uint);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function totalSupply() external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);

}

contract LockTimeOfToken {
    遍历LockDetail[] 所得到该token所在的下标
    uint index;

    最后期限和锁定的数量
    struct LockDetail{
        uint ddl;
        uint amount;
        address token;
    }

    mapping(address = address[]) tokenAddress1;

    地址 = (最后期限，锁定的数量 ,token)
    mapping(address = LockDetail[]) ownerLockDetail;

    function lock(address _token,uint deadLine,uint amount) public {
        require(deadLine = block.timestamp,'ddl should be bigger than ddl current time');
        require(amount  0 ,'token amount should be bigger than zero');
        address owner = msg.sender;

         LockDetail memory lockDetail = ownerLockDetail[msg.sender][(ownerLockDetail[msg.sender]).length];
        LockDetail memory lockDetail;
        lockDetail.ddl = deadLine;
        lockDetail.amount = amount;
        lockDetail.token = _token; 
        tokenAddress1[msg.sender].push(_token);
        ownerLockDetail[msg.sender].push(lockDetail);
        IERC20(_token).transferFrom(owner,address(this),amount);
    }

    function unlock(address _token) public{
        uint len = ownerLockDetail[msg.sender].length;
        for(uint i = 0; i  len - 1; i++ ){
            if(ownerLockDetail[msg.sender][i].token == _token){
                index = i;
            }
        }
        require(block.timestamp = ownerLockDetail[msg.sender][index].ddl,'current time should be bigger than ddl');
        uint amount = ownerLockDetail[msg.sender][index].amount;
        uint amount = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(msg.sender, amount);
    }

    function getAmount() public view returns(uint) {
        return ownerLockDetail[msg.sender][index].amount;
    }
    获取最后期限
    function getDdl() public view returns(uint) {
        return ownerLockDetail[msg.sender][index].ddl;
    }

    function getTokenName() public view returns(string memory) {
        return IERC20(ownerLockDetail[msg.sender][index].token).name();
    }

    function getTokenSymbol() public view returns(string memory) {
        return IERC20(ownerLockDetail[msg.sender][index].token).symbol();
    }

    function getTokenDecimals() public view returns(uint) {
        return IERC20(ownerLockDetail[msg.sender][index].token).decimals();
    }

    function getToken() public view returns(address[] memory) {
        return tokenAddress1[msg.sender];
    }
}