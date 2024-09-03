// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList {
    struct Task {
        string name;
        bool isCompleted;
    }
    Task[] public list;

    function addTask(string memory name) external  {
        list.push(Task(name, false));
    }

    function changeName(uint index, string memory newName) external {
        list[index].name = newName;
    }

    function setStatus(uint index, bool isDone) external {
        list[index].isCompleted = isDone;
    }

    function toggleStatus(uint index) external {
        list[index].isCompleted = !list[index].isCompleted;
    }

    function getTask(uint index) external view returns(string memory, bool){
        Task storage target = list[index];
        return (target.name, target.isCompleted);
    }

}