<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="RMPPriceRegister.aspx.cs" Inherits="Admin_Goods_RMPPriceRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>    
    <script>
        //RMP 가격등록 팝업
        function fnSearchRMPPopup(pageNo) {
               
               fnOpenDivLayerPopup('txtPopSearchRMP');
               var pageSize = 15;
               var callback = function (response) {

                   $("#tblPopList").empty();

                   if (!isEmpty(response)) {

                       var RMPList = "";
                       var num = 1;

                       $.each(response, function (key, value) {

                           $('#hdBoardTotalCount').val(value.TotalCount);

                           RMPList += '<tr class="RMPList" ondblclick="dbClick()">'
                           RMPList += '<td class="txt-center">' + num + '</td>'
                           RMPList += '<td class="txt-center compCode">' + value.Company_Code + '</td>'
                           RMPList += '<td class="txt-center compName">' + value.Company_Name + '</td>'
                           RMPList += '</tr>'

                           num++;
                           
                       });//each() end

                       $("#tblPopList").append(RMPList);
                       fnCreatePagination('RMPpagination', $("#hdBoardTotalCount").val(), pageNo, pageSize, getRMPPageData);
                       $('#tblPopList').children().css('cursor', 'pointer');

                   } else {
                       RMPList += "<tr >"
                       RMPList += "<td  class='txt-center' colspan='3' >조회된 데이터가 없습니다.</td>"
                       RMPList += "</tr>"
                       $("#tblPopList").append(RMPList);

                   } //if~else end

                   return false;

               }; // var callback

               var param = {
                   Keyword: $("#txtSaleCompSearch").val(),
                   Target: $("#searchTarget").val(),
                   Gubun: "IU",
                   PageNo: pageNo,
                   PageSize: pageSize,
                   Flag: 'GetCompListByGubun'
               };

               JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
           }

        //팝업 페이지
       function getRMPPageData() {
            var container = $('#RMPpagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearchRMPPopup(getPageNum);
            return false;
        }

        //더블클릭시
        function dbClick() {
            fnPopupOkSaleComp();
        }

      

        //popup 확인 
        function fnPopupOkSaleComp() {

            var tr = $('.on');
            var compCode = tr.children('.compCode').text(); 
            var compName = tr.children('.compName').text(); 
            if (compCode && compName != null) {

                $('#updateCode').text(compCode);
                $('#updateName').text(compName); 
                $('#txtPopSearchRMP').fadeOut();
            } else {
                alert("RMP 회사를 선택해주세요.");
            }
        }


      //insert
        function myFunction() {

            if ($('#updateCode').text() == "") {
                alert("회사명을 선택해주세요.");
            } else if ($('#socialPrice').val() == "") {
                alert("소셜위드 기준 가격을 입력해주세요.");
            } else if ($('#RMPPrice1').val() == "") {
                alert("RMP 기준 가격을 입력해주세요.");
            } else {

                var result = confirm("등록시 이전 Data는 사용중지 됩니다. 계속 하시겠습니까?");
                if (result) {

                    var callback = function (response) {

                        if (response == 'OK') {

                            alert("등록되었습니다.");
                            $('#updateCode').text("")
                            $('#updateName').text("")
                            $('#socialPrice').val("");
                            $('#RMPPrice').val("");
                            $('#RMPPrice1').val("");
                            $('#goodsPrice').val("");

                            $("#txtdate").val($.datepicker.formatDate('yymmdd', new Date()));
                            $("#txtdate").attr('placeholder', $.datepicker.formatDate('yy-mm-dd', new Date()));

                            var date = new Date();
                            date.setFullYear(date.getFullYear() + 1);
                            $("#txtdate2").val($.datepicker.formatDate('yy-mm-dd', date));
                            $("#txtdate2").attr('placeholder', $.datepicker.formatDate('yy-mm-dd', date));

                        } else {
                            alert('시스템 오류입니다. 관리자에게 문의하세요.');
                        }
                        return false;
                    }; //callback end

                    var param = {
                        company_Code: $('#updateCode').text(),
                        startDate: $('#txtdate').val(),
                        endDate: $('#txtdate2').val(),
                        SWPPriceP: $('#socialPrice').val(),
                        RMPPriceP1: $('#RMPPrice').val(),
                        RMPPriceP2: $('#RMPPrice1').val(),
                        saleCompPriceP: $('#goodsPrice').val(),
                        Flag: 'InsertRmpCompPrice'
                    }; //param end

                    JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');

                } else {
                    alert("등록되지 않았습니다.");
                }
            }

        }// end


        $(function () {

          //RMPList
             $("#tblPopList").on("click", "tr", function (e) {
                $('tr').removeClass('on');
                var tr = $(this);

                if (tr.hasClass('RMPList')) {
                tr.addClass('on');
                }
            });// on() end

            //달력
            $("#txtdate").inputmask("9999-99-99");

            $("#txtdate").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
            });

            //현재날짜
            $("#txtdate").val($.datepicker.formatDate('yymmdd', new Date()));
            $("#txtdate").attr('placeholder', $.datepicker.formatDate('yy-mm-dd', new Date()));
            $("#txtdate2").inputmask("9999-99-99");
            $("#txtdate2").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
            });

            //현재날짜에서 1년뒤
            var date = new Date();
            date.setFullYear(date.getFullYear() + 1);
            $("#txtdate2").val($.datepicker.formatDate('yy-mm-dd', date));
            $("#txtdate2").attr('placeholder', $.datepicker.formatDate('yy-mm-dd', date));

        });

        //소셜위드 기준
        function fnSocialWith() {
            var $socialPrice = $("#socialPrice").val();
            //console.log(100 - $socialPrice);
            if ($socialPrice > 100) {
                alert("100이상 입력하실 수 없습니다.");
                $("#socialPrice").val("");
                $("#RMPPrice").val("");
                $("#socialPrice").focus();
                return false;
            } else {
                var getNumber = RegExp(/^[0-9]+$/);
                if (!getNumber.test($socialPrice)) {
                    alert("숫자만 입력해주세요")
                    $("#socialPrice").val("");
                    $("#RMPPrice").val("");
                    $("#socialPrice").focus();
                    return false;
                }
            }
            $("#RMPPrice").val(100 - $socialPrice);
        }; //end

        //RMP 기준
         function fnRMPPrice() {
            var $RMPPrice1 = $("#RMPPrice1").val();
            //console.log(100 - $socialPrice);
            if ($RMPPrice1 > 100) {
                alert("100이상 입력하실 수 없습니다.");
                $("#RMPPrice1").val("");
                $("#goodsPrice").val("");
                $("#RMPPrice1").focus();
                return false;
            } else {
                var getNumber = RegExp(/^[0-9]+$/);
                if (!getNumber.test($RMPPrice1)) {
                    alert("숫자만 입력해주세요")
                    $("#RMPPrice1").val("");
                    $("#goodsPrice").val("");
                    $("#RMPPrice1").focus();
                    return false;
                }
            }
            $("#goodsPrice").val(100 - $RMPPrice1);
        }; //end

        //엔터방지
        function preventEnter(event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                return false;
            }
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div" style="min-height: 1500px">
        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                RMP 가격관리
                    <span class="span-title-subsentence"></span>
            </p>
        </div>
        <!--탭영역-->
        <div class="div-main-tab" style="width: 100%;">
            <ul>
                <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('RMPPriceManagement');">
                    <a onclick="fnTabClickRedirect('RMPPriceManagement');">RMP 가격관리</a>
                </li>
                <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('RMPPriceRegister');">
                    <a onclick="fnTabClickRedirect('RMPPriceRegister');">RMP 가격등록</a>
                </li>
            </ul>
        </div>
        <div class="bottom-search-div" style="margin-bottom: 20px">
            <table class="tbl_search" style="margin-top: 30px; margin-bottom: 30px;">
                <tr>
                    <td style="width: 200px; text-align: right;">
                        <select id="searchTarget">
                            <option value="COMPNAME">회사명</option>
                            <option value="COMPCODE">회사코드</option>
                        </select>
                    </td>
                    <td>
                        <input type="text" placeholder="RMP 검색하시오." style="width: 600px;" ID="txtSaleCompSearch" OnKeyPress="return fnSaleCompSearchEnter();" />
                        <asp:Button runat="server" CssClass="mainbtn type1" ID="Button2" Text="검색" Width="75" Height="25" Style="vertical-align: middle;" OnClientClick="fnSearchRMPPopup(1); return false;" />
                    </td>
                </tr>
            </table>
        </div>

        <!-- RMP 가격등록 -->
        <div class="result-wrap">
            <table class="tbl_main">
                <colgroup>
                    <col style="width:180px;">
                    <col>
                </colgroup>
                <tbody id="tblPriceAdd">
                    <tr>
                        <th>RMP 회사코드</th>
                        <td id="updateCode"></td>
                    </tr>
                    <tr>
                        <th>RMP 회사명</th>
                        <td id="updateName"></td>
                    </tr>
                    <tr class="height">
                        <th>시작일</th>
                        <td>
                            <input type="text" id="txtdate" class="calendar" maxlength="10" placeholder="2018-01-01">
                        </td>
                    </tr>
                    <tr class="height">
                        <th>종료일</th>
                        <td>
                            <input type="text" id="txtdate2" class="calendar" maxlength="10" placeholder="2018-01-01">
                        </td>
                    </tr>
                </tbody>
            </table>
            <p>[소셜위드 기준]</p>
            <table class="tbl_main">
                <colgroup>
                    <col style="width:180px;">
                    <col>
                </colgroup>
                <tbody>
                    <tr class="height">
                        <th>소셜 가격(%)</th>
                        <td>
                            <input type="text" id="socialPrice" onkeyup="return fnSocialWith();" onkeydown="return preventEnter(event);" oninput="return maxLengthCheck(this)" MaxLength="3" onkeypress="return onlyNumbers(event);" /></td>
                    </tr>
                    <tr class="height">
                        <th>RMP 가격(%)</th>
                        <td>
                            <input type="text" id="RMPPrice" readonly /></td>
                    </tr>
                </tbody>
            </table>
            <p>[RMP 기준]</p>
            <table class="tbl_main">
                <colgroup>
                    <col style="width:180px;">
                    <col>
                </colgroup>
                <tbody>
                    <tr class="height">
                        <th>RMP 가격(%)</th>
                        <td>
                            <input type="text" id="RMPPrice1" onkeyup="return fnRMPPrice();" onkeydown="return preventEnter(event);" oninput="return maxLengthCheck(this)" MaxLength="3" onkeypress="return onlyNumbers(event);" /></td>
                    </tr>
                    <tr class="height">
                        <th>판매사 가격(%)</th>
                        <td>
                            <input type="text" id="goodsPrice" readonly /></td>
                    </tr>
                </tbody>
            </table>
            <div class="bt-align-div">
                <input class="mainbtn type1" id="Button1" type="button" value="등록" style="vertical-align: middle; width: 75px; height: 25px;" onclick="return myFunction();" />
            </div>
        </div>

    </div>

      <%--RMP 가격관리 팝업--%>
    <div id="txtPopSearchRMP" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height:300px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('txtPopSearchRMP'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <h3 class="pop-title">RMP 회사검색</h3>
                <table class="tbl_main">
                    <thead>
                        <tr>
                           <th>순번</th>
                           <th>RMP 회사코드</th>
                           <th>RMP 회사명</th>
                        </tr>
                      </thead>
                      <tbody id="tblPopList">
                          
                         </tbody>
                     </table>
                <!--페이징-->
                <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                    <input type="hidden" id="hdBoardTotalCount" />
                    <div id="RMPpagination" class="page_curl" style="display: inline-block"></div>
                </div>
                <!--페이징 끝-->
                     <div class="btn_center">
                        <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="fnPopupOkSaleComp(); return false;" />
                    </div>   
                </div>
            </div>
        </div>

</asp:Content>

