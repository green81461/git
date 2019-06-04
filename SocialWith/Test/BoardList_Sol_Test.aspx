﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="BoardList_Sol_Test.aspx.cs" Inherits="Test_BoardList_Sol_Test" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="../Content/board.css" />
    <script type="text/javascript">

        function fnGoWrite() {

            // 아래 부분 소스 주석 풀고 커밋하기....

            var userid = '<%= Request.Cookies["LoginID"].Value %>'; //로그인 정보(세션) 갖고오기

            if (userid == '' || userid == null) {
                //정보가 없으면 비회원 문의 페이지로 이동
                location.href = 'boardinsertbynonmember.aspx'
            }
            else {
                //정보가 있으면 회원 문의 페이지로 이동
                location.href = 'boardinsertbymember.aspx'
            }
            return false;
        }

        // 게시글 제목 클릭 시 비밀번호 입력 modal 관련 처리
        function fnPwdModal(pwd, svId) {
            var userid = '<%= Request.Cookies["LoginID"].Value %>'; //로그인 정보(세션) 갖고오기

            // 비회원일 경우에만 Modal 띄움.
            if ((userid != null) && (userid != "")) {
                location.href = "BoardView.aspx?Svid=" + svId;
                return false;
            } else {
                $("#myPwdModal").modal("show"); // 비밀번호 입력 팝업 띄움.
            }

            // modal 에서 OK 버튼 클릭 시
            $("#btnPwd").unbind("click").bind("click", function () {
                var inputPwd = $("#txtPwd").val().trim(); // 사용자가 비번 입력한 값

                var param = 'TextPwd=' + inputPwd + '&UserPwd=' + pwd;

                var result = false; // 비번 비교 결과(true: 맞음, false: 틀림)
                var statusResult = false; // ajax 통신 결과 상태(true: 성공, false: 실패)

                // 비밀번호 비교 위해
                $.ajax({
                    url: 'ComparePWD.aspx',
                    type: "GET",
                    async: false,
                    cache: false,
                    data: param,
                    dataType: "json",
                    success: function (response) {

                        result = response;
                        statusResult = true;

                    },
                    error: function (xhr, status, error) {
                        alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                        statusResult = false;
                        $("#myPwdModal").modal("hide");
                    }
                });

                // 비밀번호가 맞을 경우
                if (result == true) {
                    location.href = "BoardView.aspx?Svid=" + svId;

                    // 비밀번호가 맞지 않을 경우
                } else if (statusResult == true) {
                    if (inputPwd.length == 0) {
                        alert("비밀번호를 입력해 주세요.");

                    } else {
                        alert("입력하신 비밀번호가 맞지 않습니다.\n다시 입력해 주세요.");
                    }

                    $("#txtPwd").val(""); // 비밀번호 입력창 값 초기화
                    $("#txtPwd").focus(); // 비밀번호 입력창에 포커스

                    return false;
                }

            });

            // modal 창이 보여질 때 비밀번호 입력창에 포커스
            $("#myPwdModal").on('shown.bs.modal', function () {
                $("#txtPwd").focus();
            });

            // modal 창이 없어질 때 비밀번호 입력창 값 초기화
            $("#myPwdModal").on('hide.bs.modal', function () {
                $("#txtPwd").val("");
            });
        }

        function fnEnter() {


        }
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnProfitListBind(getPageNum);
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <body onselectstart="return false">
        <!-- 게시글 비밀번호 입력 Modal 시작 -->
        <div class="modal fade" id="myPwdModal" role="dialog">
            <div id="pwdModalDiv" class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <img src="../Images/sub_pass_write_bg.jpg" alt="비밀번호" />
                    </div>
                    <div class="modal-body">
                        <p>* 비회원은 <strong>1:1 문의시 입력한 비밀번호</strong>를 입력해 주세요.</p>
                    </div>
                    <div class="modal-footer">
                        <%--<asp:TextBox ID="txtPwd" runat="server"></asp:TextBox>
                    <asp:Button ID="btnPwd" runat="server" class="btn btn-default" data-dismiss="modal" Text="OK" OnClick="btnPwd_Click"/>--%>
                        <input type="password" id="txtPwd" name="txtPwd" class="pwd-input" />
                        <button id="btnPwd" class="btn" data-dismiss="modal"></button>
                    </div>
                </div>

            </div>
        </div>
        <!-- 게시글 비밀번호 입력 Modal 끝 -->

        <!--1:1문의 게시판 시작-->
        <div class="sub-contents-div">


            <div class="sub-title-div">
                <img src="/images/BoardList_nam.png" />
                <%--<p class="p-title-mainsentence">
                       1:1 문의
                       <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
            </p>--%>
            </div>

            <div>
                <script>
                    $(function () {
                        lvBoardList(1);
                    });

                    function btnSearch_Click() {
                        lvBoardList(1);
                        return false;
                    }

                    function enterPress(e) {
                        if (e.keyCode == 13) {
                            btnSearch_Click();
                            return false;
                        }
                    }

                    function statusCon(status) {
                        var tmp = '';

                        if (status == 'Y') {
                            tmp = '답변완료';
                        } else {
                            tmp = '진행중';
                        }
                        return tmp;
                    }

                    function lvBoardList(pageNo) {

                        var pageSize = 20;

                        var callback = function (response) {
                            if (!isEmpty(response)) {
                                var rowCont = '';

                                $.each(response, function (key, value) {
                                    $("#hdTotalCount").val(value.TotalCount);
                                    var Board_RegDate = fnOracleDateFormatConverter(value.Board_RegDate);                                    
                                    
                                    rowCont += "<tr><td>" + value.RowNum + "</td><td>" + value.Board_Write + "</td><td class='align-left'>" + value.Board_Title +
                                        "</td><td>" + value.Board_Type + "</td><td>" + Board_RegDate + "</td><td>" + statusCon(value.Board_Detail.Result_Status) + "</td></tr>";
                                });

                                $("#lvBoardCont").empty().append(rowCont);

                            } else {
                                $("#hdCompTotalCount").val(0);
                                var emptyCont = "<tr><td colspan='6'>조회된 데이터가 없습니다.</td></tr>"
                                $("#lvBoardCont").empty().append(emptyCont);
                            }

                            fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getPageData);
                            return false;
                        }
                        var param = {
                            SvidUser: '<%= Svid_User%>',
                            SearchTarget: $("#ddlSearchTarget").val(),
                            SearchKeyword: $("#txtSearch").val(),
                            Gubun: 2,
                            PageNo: pageNo,
                            PageSize: pageSize,
                            Method: 'GetBoardList'
                        };

                        //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
                        JqueryAjax('Post', '../Handler/BoardHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
                    }
                </script>
                <table id="tblHeader" class="tbl_main">
                    <thead>
                        <tr>
                            <th style="width:30px">번호</th>
                            <th style="width:120px">작성자</th>
                            <th style="width:auto">제목</th>
                            <th style="width:120px">문의구분</th>
                            <th style="width:120px">등록일</th>
                            <th style="width:120px">진행단계</th>
                        </tr>
                    </thead>
                    <tbody id="lvBoardCont"></tbody>
                </table>

                <%--페이징처리--%>
                <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                    <input type="hidden" id="hdTotalCount" />
                    <div id="pagination" class="page_curl" style="display: inline-block"></div>
                </div>
            </div>
            <%--드롭다운 및 검색--%>
            <div class="bottom-search-div">
                <table class="board-search-table">
                    <tr>
                        <td style="text-align: center;">
                            <select id="ddlSearchTarget">
                                <option value="Title">제목</option>
                                <option value="Writer">작성자</option>
                            </select>

                            <input id="txtSearch" style="width:500px; height:30px;" onKeypress="return enterPress(event);"/>
                            <button id="btnSearch" style="margin-left:10px; margin-right:-2px; width:117px; height:30px; color:white; font-weight:600; background-color:#3e3e46;" onclick="return btnSearch_Click();">검색</button>
                            <button id="btnGoInsert" style="width:117px; height:30px; color:white; font-weight:600; background-color:#3e3e46;">1:1 문의하기</button>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="left-menu-wrap" id="divLeftMenu">
                <dl>
                    <dt style="border-bottom: 1px solid #eaeaea;">
                        <strong>고객센터</strong>
                    </dt>
                    <dd>
                        <a href="/Notice/NoticeList.aspx">공지사항</a>
                    </dd>
                    <dd class="active">
                        <a href="/Board/BoardList.aspx">질문게시판</a>
                    </dd>
                    <dd>
                        <a href="/Other/Faq.aspx">FAQ</a>
                    </dd>
                    <%--<dd>
		           <a>담당자 전화번호</a> 
		        </dd>--%>
                </dl>
            </div>
        </div>
    </body>
    <!--1:1문의 게시판 끝-->

    <script type="text/javascript">
        $(function () {

            $(".priority-company>a").on("mouseover focus", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("out.jpg", "over.jpg"));
            });


            $(".public>a").on("mouseover focus", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("out.jpg", "over.jpg"));
            });

            $(".public").on("mouseleave", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("over.jpg", "out.jpg"));
            });

            $(".priority-company").on("mouseleave", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("over.jpg", "out.jpg"));
            });
        });

    </script>
</asp:Content>
