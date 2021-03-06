/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function clearPayment(){
            if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
    }

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
    }

    function updateEmployeeOnly(address e) {
        require(msg.sender == owner&&e != 0x0);
        //Only the boss can update the employee
        //the employee address cannot be 0x0
        clearPayment();
        employee = e;
    }

    function updateSalaryOnly(uint s) {
        require(msg.sender == owner&&s > 0);
        //Only the boss can update the employee
        //the salary (the amount of ether) should be positive
        assert(employee!=0x0);
        //the employee address cannot be 0x0
        clearPayment();
        salary = s * 1 ether;
        lastPayday = now;
    }

    function addFund() payable returns (uint) {
        require(msg.sender == owner);
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        require(salary>0);
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() returns (bool) {
        require(msg.sender == employee);
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        assert(hasEnoughFund());

        lastPayday = nextPayday;
        employee.transfer(salary);
        return true;//if sucessful, return true
    }
}
