<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
         pageEncoding="ISO-8859-1" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!-- HEADER -->
<jsp:include page="../common/header.jsp"/>

<!-- Begin Page Content -->
<div class="container-fluid">


    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Employee List
                <a href="${ pageContext.request.contextPath }/employee/add"
                   class="btn btn-primary btn-icon-split float-right">
                    <span class="icon text-white-50">
                      <i class="fas fa-plus"></i>
                    </span>
                    <span class="text">Register New Employee</span>
                </a></h6>
        </div>
        <div class="card-body">

            <div class="alert alert-success mt-4" id="alert" role="alert" style="display:none;">
                Payment successful!
            </div>

            <div class="table-responsive">


                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Grade</th>
                        <th>Salary</th>
                        <th></th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${ users }" var="user">
                        <tr>
                            <td>${ user.id }</td>
                            <td>${ user.username }</td>
                            <td>${ user.grade }</td>
                            <td>${ user.salary }</td>
                            <td>
                                <button class="btn btn-success btn-icon-split" data-toggle="modal"
                                        data-target="#payModalCenter${ user.id }"
                                        onclick="setValue('${ user.id }', '${user.username}', '${user.salary}')">
                                    <span class="icon text-white-50"><i class="fas fa-dollar-sign"></i></span>
                                    <span class="text">Pay</span>
                                </button>

                                <!-- Modal -->
                                <div class="modal fade text-center" id="payModalCenter${ user.id }" tabindex="-1"
                                     role="dialog"
                                     aria-labelledby="payModalCenterTitle" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="payModalCenterTitle">Pay Salary to
                                                        ${user.username}</h5>
                                                <button type="button" class="close" data-dismiss="modal"
                                                        aria-label="Close">
                                                    <span aria-hidden="true">&times;</span>
                                                </button>
                                            </div>
                                            <div class="modal-body">
                                                <h1 class="font-weight-bold ">${ user.salary }<sup
                                                        class="small"><small>BDT</small></sup></h1>
                                            </div>
                                            <div class="modal-footer">
                                                <c:choose>
                                                    <c:when test="${balance >= user.salary}">
                                                        <button type="button" class="btn btn-success btn-block"
                                                                id="rechargeMoneyBtn${ user.id }">Confirm
                                                        </button>
                                                        <a id="insufficientAlert${ user.id }" href="/settings/bank"
                                                           class="btn btn-danger btn-block d-none">
                                                            Insufficient Balance (Please recharge)
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="/settings/bank" class="btn btn-danger btn-block">
                                                            Insufficient Balance (Please recharge)
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                            </td>
                            <td>
                                <button class="btn btn-primary btn-icon-split" data-toggle="modal"
                                        data-target="#detailModalScrollable${ user.id }">
                                    <span class="icon text-white-50"><i class="fas fa-info-circle"></i></span>
                                    <span class="text">Details</span>
                                </button>

                                <!-- Modal -->
                                <div class="modal fade" id="detailModalScrollable${ user.id }" tabindex="-1"
                                     role="dialog"
                                     aria-labelledby="detailModalScrollableTitle" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-scrollable  modal-lg" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="detailModalScrollableTitle">
                                                    <b>${user.username}</b>'s Details</h5>
                                                <button type="button" class="close" data-dismiss="modal"
                                                        aria-label="Close">
                                                    <span aria-hidden="true">&times;</span>
                                                </button>
                                            </div>
                                            <div class="modal-body">

                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary w-100"
                                                        data-dismiss="modal">
                                                    Close
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>
<!-- /.container-fluid -->

<script>

let id, username, amount

function setValue (id, username, amount) {
  this.id = id
  this.username = username
  this.amount = amount
  // log selected user info
  // console.log(id + username + amount)

  if ($('#currentBalance').text() < amount) {

    $('#rechargeMoneyBtn' + id).addClass('d-none')
    $('#insufficientAlert' + id).removeClass('d-none')

  } else {

    $('#rechargeMoneyBtn' + id).removeClass('d-none')
    $('#insufficientAlert' + id).addClass('d-none')

    $('#rechargeMoneyBtn' + id).on('click', function () {
      rechargeMoney(id, username, amount)
    });

  }
}

function rechargeMoney (id, username, amount) {
  $.post("/api/v1/pay-employee", {
    username: username,
    amount: amount,
  }, function (data, status) {
    console.log(data);
    if (data.msg == 'success') {
//    hide the modal
      setTimeout(function () {
        $('#payModalCenter' + id).click()
        $('#payModalCenter' + id).click()
      }, 200);

      showAlertSuccess(username, amount, data.currentBalance)
    } else {
      showAlertFailed(id, amount, data.currentBalance)
    }
  });
}

function showAlertSuccess (username, amount, currentBalance) {
  $('#alert').show()
  $('#alert').text("Paid salary: " + amount + " successful to: " + username)
  $('#currentBalance').removeClass('text-success')
  $('#currentBalance').addClass('text-danger')
  $('#currentBalance').text(currentBalance)

  setTimeout(function () {
    $('#alert').hide()
    $('#currentBalance').removeClass('text-danger')
    $('#currentBalance').addClass('text-success')
  }, 4000)
}

function showAlertFailed (id, amount, currentBalance) {
  if (amount > currentBalance) {
    $('#rechargeMoneyBtn' + id).addClass('d-none')
    $('#insufficientAlert' + id).removeClass('d-none')
  } else {
    $('#rechargeMoneyBtn' + id).removeClass('d-none')
    $('#insufficientAlert' + id).addClass('d-none')
  }

  setTimeout(function () {
    $('#payModalCenter' + id).click()
    $('#payModalCenter' + id).click()
  }, 200);
}
</script>

<!-- FOOTER -->
<jsp:include page="../common/footer.jsp"/>