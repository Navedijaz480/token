/**
 *Submitted for verification at testnet.bscscan.com on 2024-04-17
*/

/**
 *Submitted for verification at testnet.bscscan.com on 2024-03-28
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract  TestToken is Context, IBEP20 {
    using SafeMath for uint256;
    mapping (address => uint256) public _balances;
     mapping (address => uint256) public selling;
     mapping (address => uint256) public buying;
     mapping (address=>bool) public  blacklist;

    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) public _isExcluded;
    // transfer conditions mapping
  
    mapping(address => uint256) public _totTransfers;

    //pancake/uniswap/sunswap selling condition 
    mapping(address => uint256) public _totalAmountSell;

     //pancake/uniswap/sunswap selling condition
    mapping(address => uint256) public _totalAmountSellpercent;


    // pancake/uniswap/sunswap buying condition
  
    mapping(address => uint256) public _totalAmountBuy;

    // multisendtoken receiver condition
    
    mapping(address => uint256) public _totalAmountreceive;


    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;


      address public pancakePair;
    
       address public owner;
       address public marketingwallet=0xcb06C621e1DCf9D5BB67Af79BEa90Ac626e4Ff38;
       uint256 public sellmarketingFee = 4;
       uint256 public buymarketingFee = 5;

       bool public isTradingActive;

     function EnableTrading() external onlyOwner{
        isTradingActive=true;
     }

      function disableTrading() external onlyOwner{
        isTradingActive=false;
     }

    constructor ()  {
        _name = "TestToken";
        _symbol ="JJR";
        _totalSupply = 1000000000e18;
        _decimals = 18;
        _isExcluded[msg.sender]=true;
        _isExcluded[address(this)]==true;

        owner=msg.sender;
        marketingwallet=owner;
              
          _balances[owner] = _totalSupply;
                  _paused = false;
        emit Transfer(address(0), owner, _totalSupply);
        
    }

     modifier onlyOwner() {
        require(msg.sender==owner, "Only Call by Owner");
        _;
    }

    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
 

      


    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    function pauseContract() public onlyOwner{
        _pause();

    }
    function unpauseContract() public onlyOwner{
        _unpause();

    }

//         
    // 





    

    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) public virtual whenNotPaused override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address _owner, address spender) public view virtual override returns (uint256) {
        return _allowances[_owner][spender];
    }
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public virtual whenNotPaused returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual whenNotPaused returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal whenNotPaused virtual {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");
        require(blacklist[sender]==false,"you are blacklisted");
        require(blacklist[recipient]==false,"you are blacklisted");
        _beforeTokenTransfer(sender, recipient, amount);  
        
         if(sender==owner && recipient == pancakePair  ){
        _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);	
         selling[sender]=selling[sender].add(amount);

        }    

          else if(sender==owner){
            _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].add(amount);
        }
////////////////////////////////////////////////////////////////////////        
                    // Selling limits
// ////////////////////////////////////////////////////////////////////
        else if (recipient == pancakePair ){
        if(_isExcluded[sender]==false ){
        require(isTradingActive==true,"Trading is off!");
    
        		 
			
				_totalAmountSell[sender]= _totalAmountSell[sender].add(amount);
                 _balances[sender] = _balances[sender].sub(amount, "BEP20: sell amount exceeds balance 1");
                _balances[marketingwallet]=_balances[marketingwallet].add(calculatesellmarketingFee(amount));
                 uint256 remaining=amount.sub(calculatesellmarketingFee(amount));
               _balances[recipient] = _balances[recipient].add(remaining);
	
        }
        else{

            _balances[sender] = _balances[sender].sub(amount, "BEP20: selling amount exceeds balance 3");
            _balances[recipient] = _balances[recipient].add(amount);
            _totalAmountSell[sender] =_totalAmountSell[sender].add(amount);
        }

			}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
                              // Buying Condition
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        // else if(sender==pancakePair) {

        // if(_isExcluded[recipient]==false ){
        // require(isTradingActive==true,"Trading is off!");
       			 
			
		// 		_totalAmountBuy[recipient]= _totalAmountBuy[recipient].add(amount);
        //          _balances[sender] = _balances[sender].sub(amount, "BEP20: buy amount exceeds balance 1");
        //         _balances[marketingwallet]=_balances[marketingwallet].add(calculatebuymarketingFee(amount));
        //          uint256 remaining=amount.sub(calculatebuymarketingFee(amount));
        //         _balances[recipient] = _balances[recipient].add(remaining);
	
        // }

        else if (recipient == pancakePair ){
    if(_isExcluded[sender]==false ){
        require(isTradingActive==true,"Trading is off!");
        _totalAmountSell[sender]= _totalAmountSell[sender].add(amount);
        uint256 taxAmount = calculatesellmarketingFee(amount);
        _balances[sender] = _balances[sender].sub(amount, "BEP20: sell amount exceeds balance 1");
        _balances[marketingwallet]=_balances[marketingwallet].add(taxAmount);
        uint256 remaining=amount.sub(taxAmount);
        _balances[recipient] = _balances[recipient].add(remaining);
    }

    
        else{
            _balances[sender] = _balances[sender].sub(amount, "BEP20: buy amount exceeds balance 3");
            _balances[recipient] = _balances[recipient].add(amount);
            _totalAmountBuy[recipient] =_totalAmountBuy[recipient].add(amount);
        }
            

        }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // exclude receiver
///////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
else if(_isExcluded[recipient]==true )
       {
           _balances[sender] = _balances[sender].sub(amount, "BEP20: simple transfer amount exceeds balance 3");
            _balances[recipient] = _balances[recipient].add(amount);
       }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                // simple transfer
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       else if(_isExcluded[sender]==false ){		 		
				_totTransfers[sender]= _totTransfers[sender].add(amount);
                 _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance 1");
                _balances[recipient] = _balances[recipient].add(amount);
		

             
       }
// ///////////////////////////////////////////////////////////////////////////////////
                            // tranfer for excluded accounts
//////////////////////////////////////////////////////////////////////////////////////
       else if(_isExcluded[sender]==true )
       {
           _balances[sender] = _balances[sender].sub(amount, "BEP20: simple transfer amount exceeds balance 3");
            _balances[recipient] = _balances[recipient].add(amount);
       }
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address _owner, address spender, uint256 amount) internal whenNotPaused virtual {
        require(_owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");
        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

      function _mint(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 value) public whenNotPaused {
        require(account != address(0), "BEP20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    function addpairaddress(address _pair) public onlyOwner whenNotPaused{
        pancakePair=_pair;

    }
        
    function transferownership(address _newonwer) public whenNotPaused onlyOwner{
        owner=_newonwer;
    }

  
    function addtoblacklist(address _addr) public onlyOwner whenNotPaused{
        require(blacklist[_addr]==false,"already blacklisted");
        blacklist[_addr]=true;
    }

    function removefromblacklist(address _addr) public onlyOwner whenNotPaused{
        require(blacklist[_addr]==true,"already removed from blacklist");
        blacklist[_addr]=false;
    }

  
    
    
    
    function withDraw (uint256 _amount) onlyOwner public whenNotPaused
    {
        payable(msg.sender).transfer(_amount);
    }
    
    
    function getTokens (uint256 _amount) onlyOwner public whenNotPaused
    {
        _transfer(address(this),msg.sender,_amount);
    }
    function ExcludefromLimits(address _addr,bool _state) public onlyOwner whenNotPaused{
        _isExcluded[_addr]=_state;
    }

   
    function setMarketingfeepercent(uint256  _sellmarketingFee,uint256  _buymarketingFee) external onlyOwner{
       
        sellmarketingFee=_sellmarketingFee;
        buymarketingFee=_buymarketingFee;
    }
  
    function calculatesellmarketingFee(uint256 _amount) public view returns (uint256) {
        return _amount.mul(sellmarketingFee).div(
            10**2
        );
    }
    function calculatebuymarketingFee(uint256 _amount) public view returns (uint256) {
        return _amount.mul(buymarketingFee).div(
            10**2
        );
    }

    function setMarketingWallet(address _newMarketing) external onlyOwner{
        marketingwallet=_newMarketing;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }



}