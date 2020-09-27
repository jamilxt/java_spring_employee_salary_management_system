package com.jamilxt.esmpanel.controllers;

import com.jamilxt.esmpanel.model.User;
import com.jamilxt.esmpanel.request.PaymentRequest;
import com.jamilxt.esmpanel.request.RechargeBalanceRequest;
import com.jamilxt.esmpanel.service.BankAccountService;
import com.jamilxt.esmpanel.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class MoneyTransactionRESTController {

    private final BankAccountService bankAccountService;
    private final UserService userService;

    public MoneyTransactionRESTController(BankAccountService bankAccountService, UserService userService) {
        this.bankAccountService = bankAccountService;
        this.userService = userService;
    }

    @PostMapping("/recharge-money")
    public ResponseEntity<?> rechargeMoney(@RequestParam(name = "amount") long amount) {
        RechargeBalanceRequest request = new RechargeBalanceRequest();
        request.setCurrentBalance(bankAccountService.rechargeAmountOnCompany(amount));
        return new ResponseEntity<>(request, HttpStatus.OK);
    }

    @PostMapping("/pay-employee")
    public ResponseEntity<?> rechargeMoney(@RequestParam(name = "username") String username,
                                           @RequestParam(name = "amount") String amount) {
        PaymentRequest request = new PaymentRequest();
        User user = userService.findByUsername(username).get();
        request.setMsg(bankAccountService.paySalaryToAUser(user, Long.parseLong(amount)));
        request.setCurrentBalance(String.valueOf(bankAccountService.getBankBalanceByUsername("admin")));
        return new ResponseEntity<>(request, HttpStatus.OK);
    }

}
