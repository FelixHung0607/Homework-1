// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract LiaoToken is IERC20 {
    // TODO: you might need to declare several state variable here
    mapping(address account => uint256) private _balances;
    mapping(address account => bool) isClaim;
    mapping(address account => mapping(address spender => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    event Claim(address indexed user, uint256 indexed amount);

    constructor(string memory name_, string memory symbol_) payable {
        _name = name_;
        _symbol = symbol_;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function claim() external returns (bool) {
        if (isClaim[msg.sender]) revert();
        _balances[msg.sender] += 1 ether;
        _totalSupply += 1 ether;
        emit Claim(msg.sender, 1 ether);
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        // TODO: please add your implementaiton here
         if (msg.sender == address(0)) {
            revert();
        }
        if (to == address(0)) {
            revert ();
        }
        if (msg.sender == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            _totalSupply += amount;
        } else {
            uint256 fromBalance = _balances[msg.sender];
            if (fromBalance < amount) {
                revert();
            }
            unchecked {
                // Overflow not possible: amount <= fromBalance <= totalSupply.
                _balances[msg.sender] = fromBalance - amount;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: amount <= totalSupply or amount <= fromBalance <= totalSupply.
                _totalSupply -= amount;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + amount is at most totalSupply, which we know fits into a uint256.
                _balances[to] += amount;
            }
        }

        emit Transfer(msg.sender, to, amount);
        return true;
    
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        // TODO: please add your implementaiton here
        uint256 currentAllowance = allowance(from, msg.sender);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert ();
            }
            unchecked {
                if (from == address(0)) {
                    revert();
                }
                if (msg.sender == address(0)) {
                    revert();
                }
                _allowances[from][msg.sender] = value;
                // if (emitEvent) {
                //     emit Approval(from, msg.sender, value);
                // }
            }
        }
            if (from == address(0)) {
                // Overflow check required: The rest of the code assumes that totalSupply never overflows
                _totalSupply += value;
            } else {
                uint256 fromBalance = _balances[from];
                if (fromBalance < value) {
                    revert();
                }
                unchecked {
                    // Overflow not possible: amount <= fromBalance <= totalSupply.
                    _balances[from] = fromBalance - value;
                }
            }

            if (to == address(0)) {
                unchecked {
                    // Overflow not possible: amount <= totalSupply or amount <= fromBalance <= totalSupply.
                    _totalSupply -= value;
                }
            } else {
                unchecked {
                    // Overflow not possible: balance + amount is at most totalSupply, which we know fits into a uint256.
                    _balances[to] += value;
                }
            }

            emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        // TODO: please add your implementaiton here
        if (msg.sender == address(0)) {
            revert();
        }
        if (spender == address(0)) {
            revert();
        }
        _allowances[msg.sender][spender] = amount;
        // if (emitEvent) {
        emit Approval(msg.sender, spender, amount);
        // }
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        // TODO: please add your implementaiton here
        return _allowances[owner][spender];
    }
}
