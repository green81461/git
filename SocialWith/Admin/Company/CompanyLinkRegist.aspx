﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CompanyLinkRegist.aspx.cs" Inherits="Admin_Company_CompanyLinkRegist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />

    <script>

        $(document).ready(function () {
            var tableid = 'tbSocialCompanyList';
            //var tableidUpdate = 'tbSocialCompanyListUpdate';
            ListCheckboxOnlyOne(tableid); //체크박스 하나만 체크되게..
            //ListCheckboxOnlyOne(tableidUpdate); //체크박스 하나만 체크되게..

            //$('.tblCompanyLinkRegist td a').on({
            //    click: function (e) {
            //        e.preventDefault();
            //        var target = e.target
            //        var targetClass = $(target).prop('className');

            //        switch (targetClass) {
            //            case "btnSaleCompanySearch":
            //                fnSearchCompany('SU');
            //                break;

            //            case "btnBuyCompanySearch":
            //                fnSearchCompany('BU');
            //                break;

            //            case "btnIdxCheck":
            //                fnSeqChk();
            //                break;
            //        }
            //    }
            //});

            // 연동코드생성 버튼 클릭시 코드 생성
            //$('.btnLinkCodeCreate').on("click", fnCodeGenerate);

            // 등록 버튼 클릭시
            //$('.btnLinkCodeReg').on("click", fnSocialCompInfoSave);

        });

        function fnSocialCompInfoSave(e) {
            e.preventDefault();

            var txtSeq = $('#txtSeq').val();
            var txtSdate = $('#txtSearchSdate').val();
            var txtEdate = $('#txtSearchEdate').val();
            var hfLinkCode = $('#hfLinkCode').val().trim();
            var txtLinkName = $('#txtLinkName').val().trim();
            var hfSaleCompCode = $('#hfSaleCompCode').val().trim();
            var hfBuyCompCode = $('#hfBuyCompCode').val().trim();
            var txtRemark = $('#txtRemark').val().trim();

            var chk = fnValidate(); // 연동 등록 폼 유효성 체크

            if (!chk) {
                return false;
            }


            var callback = function (response) {
                // 등록하기 전에 빈칸 확인
                alert("저장되었습니다.");
                location.href = "./CompanyLinkList.aspx?ucode=03";
            }

            var param = {
                Method: 'SaveSocialCompanyLink',
                txtSeq: txtSeq,
                tstSdate: txtSdate,
                txtEdate: txtEdate,
                hfLinkCode : hfLinkCode,
                txtLinkName : txtLinkName,
                hfSaleCompCode : hfSaleCompCode,
                hfBuyCompCode : hfBuyCompCode,
                txtRemark : txtRemark
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", false, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User %>');
        
        }

        // 관계사 연동 등록시 빈 항목이 있는지 체크하는 함수
        function fnValidate() {

            var hfLinkCode = $('#hfLinkCode');
            var txtLinkCode = $('#txtLinkCode');
            var txtLinkName = $('#txtLinkName');
            var txtSaleCompCode = $('#txtSaleCompCode');
            var txtBuyCompCode = $('#txtBuyCompCode');
            var chkSeq = $("#hdSeqChk").val();         //해당 값이 0이면 false

            if (txtLinkCode.val() == '') {
                alert('연동코드를 생성하세요.');
                txtLinkCode.focus();
                return false;
            }
            if (txtLinkName.val() == '') {
                alert('회사연동명을 입력하세요.');
                txtLinkName.focus();
                return false;
            }

            if (txtSaleCompCode.val() == '') {
                alert('판매사 회사구분코드를 검색하세요.');
                txtSaleCompCode.focus();
                return false;
            }

            if (txtBuyCompCode.val() == '') {
                alert('구매사 회사구분코드를 검색하세요.');
                txtBuyCompCode.focus();
                return false;
            }
            if (chkSeq == '0') {
                alert('관계사 연동 순번을 체크해주세요.');
                btnSeqChk.focus();
                return false;
            }

            return true;
        }

        function fnSearchCompany(gubun) {

            if (gubun == 'SU') {
                $('#lblDialogName').text('판매사 회사구분코드');
                $('#lblHeaderCode').text('판매사 회사구분코드');
                $('#lblHeaderName').text('판매사 회사구분명');
                $('#imgTitle').attr('src', '../Images/Member/a-title.jpg')
            }
            else if (gubun == 'BU') {
                $('#lblDialogName').text('구매사 회사구분코드');
                $('#lblHeaderCode').text('구매사 회사구분코드');
                $('#lblHeaderName').text('구매사 회사구분명');
                $('#imgTitle').attr('src', '../Images/Member/b-title.jpg')
            }

            $('#hfGubun').val(gubun);

            var callback = function (response) {

                $('#tbSocialCompanyList').find('tr:gt(0)').remove(); //테이블 클리어
                var index = 0;
                $.each(response, function (key, value) { //테이블 추가
                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfCompCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hfCompName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
                    newRowContent += "<td> " + value.SocialCompany_Code + " </td><td>" + value.SocialCompany_Name + "</td></tr>";
                    $('#tbSocialCompanyList tr:last').after(newRowContent);
                    index++;
                });

                fnOpenDivLayerPopup('corpCodeAdiv');
                
                return false;
            }

            var param = {
                Method: 'SocialCompanyList',
                Gubun: gubun
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        function fnSelectCompany() {
            $('#tbSocialCompanyList input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var code = $(this).next('input').val();
                    var name = $(this).next('input').next('input').val();

                    if ($('#hfGubun').val() == 'SU') {
                        $('#txtSaleCompCode').val(code);
                        $('#hfSaleCompCode').val(code); //textBox가 readOnly 이기 때문에 히든필드에 저장
                    }
                    else if ($('#hfGubun').val() == 'BU') {
                        $('#txtBuyCompCode').val(code);
                        $('#hfBuyCompCode').val(code);
                    }
                }
            });

            $('.divpopup-layer-package').fadeOut();
        }

        
        // 관게사 연동 순번 체크
        function fnSeqChk() {
            var seq = $('#txtSeq').val();
            var chkCompanyCode = $('#txtBuyCompCode').val();
            var chkSaleCompanyCode = $('#txtSaleCompCode').val();
            var plusSeq = '1';
            var txtSaleCompCode = $('#txtSaleCompCode');
            var txtBuyCompCode = $('#txtBuyCompCode');

            if (txtSaleCompCode.val() == '') {
                alert('판매사 회사구분코드를 검색하세요.');
                txtSaleCompCode.focus();
                return false;
            }

            if (txtBuyCompCode.val() == '') {
                alert('구매사 회사구분코드를 검색하세요.');
                txtBuyCompCode.focus();
                return false;
            }


            var callback = function (response) {

                $.each(response, function (key, value) {
                    //여기서 프로시저로 검색한 값 체크 후 값이 있다면 해당 값 +1하기
                    var ReturnSeq = value.SocialComapnyLinkSeq;
                    if (ReturnSeq != '0') {
                        seq = parseInt(ReturnSeq) + parseInt(plusSeq)
                        $('#txtSeq').val(seq);
                    }
                    fnOverlapChk(chkCompanyCode, chkSaleCompanyCode);
                    //alert('순번 체크가 완료되었습니다.')
                    //$("#hdSeqChk").val(1);
                });

                return false;
            }

            var param = {
                Method: 'SocialCompanyChkSeq',
                Seq: seq,
                ChkCompanyCode: chkCompanyCode
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');

        }

        //회사 중복 체크
        function fnOverlapChk(chkCompanyCode, chkSaleCompanyCode) {
            var CompanyCode = chkCompanyCode;
            var SaleCompanyCode = chkSaleCompanyCode;
            var callback = function (response) {                  //프로시저를 통해 순번코드를 받아와 중복을 체크한다.
                $.each(response, function (key, value) {
                    if (value.Result != '0') {                 //0이 아니면 중복값 있음
                        alert('중복 데이터가 있습니다.')
                        $("#hdSeqChk").val(0);                 //hdSeqChk 값이 0이면 저장할 수 없음
                        $('#txtSeq').val(1);
                    }
                    else {
                        alert('순번 체크가 완료되었습니다.')
                        $("#hdSeqChk").val(1);           // //hdSeqChk 값이 0이면 저장할 수 있음.
                    }

                });

                return false;
            }

            var param = {
                Method: 'SocialCompanyChkCom',
                ChkCompanyCode: CompanyCode,
                ChkSaleCompanyCode: SaleCompanyCode
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');

        }

        function fnCodeGenerate(e) {
            e.preventDefault();

            var callback = function (response) {
                $('#txtLinkCode').val(response);
                $('#hfLinkCode').val(response); //textBox가 readOnly 이기 때문에 히든필드에 저장
                return false;
            }
            var param = {
                Type: 'SocialCompanyLink'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Common/CodeGenerateHandler.ashx", false, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }
       

        // 탭메뉴 클릭시 해당 페이지로 이동
        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=03';
            return false;
        }

         //RMP 회사코드 팝업
        function fnComSearchPopup() {
            fnOpenDivLayerPopup('corpCodeAdiv2');
            return false;
        }

        //// 팝업 닫기
        //function fnCancel() {
        //    $('.divpopup-layer-package').fadeOut();
        //}

         //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "OHL":
                    window.location.href = "../Order/OrderHistoryList?ucode=" + ucode;
                    break;
                case "DL":
                    window.location.href = "../Order/DeliveryOrderList?ucode=" + ucode;
                    break;
                case "PG":
                    window.location.href = "../Member/Pg_Main?ucode=" + ucode;
                    break;
                case "LOAN":
                    window.location.href = "../Member/Loan_Main?ucode=" + ucode;
                    break;
                case "OBM":
                    window.location.href = "../Order/OrderBelongMain?ucode=" + ucode;
                    break;
                case "CLM":
                    window.location.href = "../Company/CompanyLinkManagement?ucode=" + ucode;
                    break;
                default:
                    break;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p class="p-title-mainsentence">관계사 연동관리</p>
    <ul class="listStyle0">
        <li><a href="#none" class="mainbtn type1" onclick="fnGoPage('PG'); return false;" >PG 관리</a></li>
        <li><a href="#none" class="mainbtn type1" onclick="fnGoPage('OBM'); return false;">주문 연동 관리</a></li>
        <li><a href="#none" class="mainbtn type1" onclick="fnGoPage('LOAN'); return false;">여신 관리</a></li>
    </ul>

<!-- S. 탭메뉴-->
    <div class="div-main-tab">
        <ul>
            <li class='tabOff' onclick="fnTabClickRedirect('CompanyLinkList');">
                <a onclick="fnTabClickRedirect('CompanyLinkList');">관계사 연동 조회</a>
            </li>
            <li class='tabOn' onclick="fnTabClickRedirect('CompanyLinkRegist');">
                <a onclick="fnTabClickRedirect('CompanyLinkRegist');">관계사 연동 등록</a>
            </li>
            <li class='tabOff' onclick="fnTabClickRedirect('CompanyLinkSeqUpdate');">
                <a onclick="fnTabClickRedirect('CompanyLinkSeqUpdate');">관계사 고정 판매사 변경</a>
            </li>
        </ul>
    </div>
<!-- E. 탭메뉴 -->

<!-- S. 관계사 연동 조회 -->
    <div class="bottom-search-div">
        <table id="tblInsert" class="tbl_main">
            <tbody>
                <tr>
                    <th>회사연동코드</th>
                    <td>
                        <input type="text" id="txtLinkCode" class="medium-size" readonly/>
                        <input type="hidden" id="hfLinkCode" />
                    </td>
                    <th>회사연동명</th>
                    <td><input type="text" id="txtLinkName" class="medium-size"/></td>
                </tr>
                <tr>
                    <th>RMP유무</th>
                    <td>
                        <select class="medium-size">
	                        <option value="no">아니오</option>
	                        <option value="yes">예</option>
                        </select>
                    </td>
                    <th>RMP회사코드</th>
                    <td>
                        <input type="text" class="medium-size"/>
                        <a href="#none" style="width:65px" class="mainbtn type1" onclick="fnComSearchPopup()">검색</a>      
                    </td>
                </tr>
                <tr>
                    <th>판매사 회사구분코드</th>
                    <td>
                        <input type="text" id="txtSaleCompCode" class="medium-size">
                        <input type="hidden" id="hfSaleCompCode" />
                        <a href="#none" style="width:65px" class="mainbtn type1 btnSaleCompanySearch" onclick="fnSearchCompany('SU')">검색</a>                        
                    </td>
                    <th>구매사 회사구분코드</th>
                    <td>
                        <input type="text" id="txtBuyCompCode" class="medium-size"/>
                        <input type="hidden" id="hfBuyCompCode" />
                        <a href="#none" style="width:65px" class="mainbtn type1 btnBuyCompanySearch" onclick="fnSearchCompany('BU')">검색</a>   
                    </td>
                </tr>
                <tr>
                    <th>관계사 연동 순번</th>
                    <td>
                        <input type="text" id="txtSeq" value="1" readonly class="medium-size"/>
                        <input type="hidden" id="hdSeqChk" name="hdSeqChk" value="0" />
                        <a href="#" class="mainbtn type1 btnIdxCheck" onclick="fnSeqChk()">순번체크</a>
                    </td>
                    <th>RMP사용유무</th>
                    <td>
                        <select class="medium-size">
	                        <option value="yes">예</option>
	                        <option value="no">아니오</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>관계사 연동 시작일</th>
                    <td><input type="text" id="txtSearchSdate" class="medium-size" maxlength="10" value="" placeholder="2018-01-01"/></td>
                    <th>관계사 연동 종료일</th>
                    <td><input type="text" id="txtSearchEdate" class="medium-size" maxlength="10" value="" placeholder="2018-12-30"/></td>
                </tr>
                <tr>
                    <th>비고</th>
                    <td colspan="3"><input type="text" id="txtRemark" class="medium-size"/></td>
                </tr>
            </tbody>
        </table>
        <div class="bt-align-div" >
            <a href="#" class="mainbtn type1" onclick="fnCodeGenerate(event)">연동코드생성</a>
            <a href="#" style="width:75px" class="mainbtn type1" onclick="fnSocialCompInfoSave(event)">등록</a>
        </div>
    </div>
<!-- E. 관계사 연동 조회 -->

<div id="PGdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('PGdiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <div class="popup-title" style="margin-top: 20px;">
                            <h3 class="pop-title">관계사 연동 수정</h3>
                    <table class="pgTblPop tbl_main tbl_popup">
                        <tr>
                            <th>연동코드</th>
                            <td>
                                <input type="text" id="LinkCode" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th>회사연동명</th>
                            <td>
                                <input type="text" id="ComName" />
                            </td>
                        </tr>
                        <tr>
                            <th>판매사 회사 구분코드</th>
                            <td>
                                <input type="text" id="SaleComCode"/>
                                <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" onclick="fnComBuyerSearchPopup('A')" />
                            </td>
                        </tr>

                        <tr>
                            <th>구매사 회사 구분코드</th>
                            <td>
                                <input type="text" id="BuyComCode" />
                                <a>
                                    <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" onclick="fnComBuyerSearchPopup('B')" /></a>
                            </td>
                        </tr>

                        <tr>
                            <th>관계사 연동 순번</th>
                            <td>
                                <input type="text" id="LinkSeq" />
                                <input type="hidden" id="hdLinkSeq" />
                                <input type="button" id="btnSchSeq" name="btnSchSeq" value="순번 검증" onclick="fnSchSeq();" />
                            </td>
                        </tr>
                        <tr>
                            <th>비고</th>
                            <td>
                                <asp:TextBox runat="server" ID="Remark" Width="99%"></asp:TextBox>
                            </td>
                        </tr>
                    </table>

                    <div class="bt-align-div">
                        <%--<asp:ImageButton runat="server" ID="btnSave" OnClick="click_save" ImageUrl="../Images/Member/save.jpg" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'" />--%>
                    </div>
                </div>
            </div>
        </div>
    </div>


<!-- S. 코드 검색 Popup 창 시작 -->
    <div id="corpCodeAdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper">
            <div class="popupdivContents">
                <div class="popup-title">
                    <h3 class="pop-title">회사구분코드검색</h3>
                </div>
                <div class="search-div">
                    <input type="text" class="text-code" placeholder="판매사명을 입력하세요" style="width:300px">
                    <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="검색">                        
                </div>
                <div class="code-div" style="height: 340px">
                    <%--이부분은 동적으로 생성되는 테이블이니까 자바스크립트 fnSearchCompany 함수 참고하시고 그부분에서 수정해주세요--%>
                    <table id="tbSocialCompanyList" class="tbl_main tbl_pop">
                        <thead>
                            <tr>
                                <th>선택</th>
                                <th>
                                    <label id="lblHeaderCode"></label>
                                </th>
                                <th>
                                    <label id="lblHeaderName"></label>
                                </th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="page_wrap">
                     <div id="pagination" class="page_curl" style="display:inline-block">
                         <div class="paginationjs">
                             <div class="paginationjs-pages">
                                 <ul>
                                     <li class="paginationjs-prev disabled" style="padding-right:3px">
                                         <a><img src="../../Images/left-arrow.jpg" style="vertical-align:middle; height:100%; cursor:pointer" onmouseover="this.src=&quot;../../Images/left-arrow-hover.jpg&quot;" onmouseout="this.src=&quot;../../Images/left-arrow.jpg&quot;"></a>
                                     </li>
                                     <li class="paginationjs-page J-paginationjs-page active" data-num="1">
                                         <a>1</a>
                                     </li>
                                     <li class="paginationjs-page J-paginationjs-page" data-num="2">
                                         <a>2</a>
                                     </li>
                                     <li class="paginationjs-next J-paginationjs-next" data-num="2" title="Next page" style="padding-left:3px">
                                         <a><img src="../../Images/right-arrow.jpg" style="vertical-align:middle; height:100%; cursor:pointer" onmouseover="this.src=&quot;../../Images/right-arrow-hover.jpg&quot;" onmouseout="this.src=&quot;../../Images/right-arrow.jpg&quot;"></a>
                                     </li>
                                 </ul>
                            </div>
                          </div>
                     </div> 
                 </div>
                <div class="btn_center">
                    <input type="button" id="btnCancel" class="mainbtn type2" style="width:75px" value="취소" onclick="fnClosePopup('corpCodeAdiv'); return false;" />
                    <input type="button" id="btnOk" class="mainbtn type1" style="width:75px" value="확인" onclick="fnSelectCompany(); return false;" />
                   <%-- <a href="#none" id="btnOk" class="btnPopOk" onclick="fnSelectCompany(); return false;">확인</a>
                    <a href="#none" id="btnCancel" class="btnPopCancle" onclick="fnCancel(); return false;">취소</a>--%>
                    <input type="hidden" id="hfGubun" value="None" />
                </div>
            </div>
        </div>
    </div>
<!-- E. 코드 검색 Popup 창 끝 -->


<!-- RMP 회사코드 검색 팝업-->
    <div id="corpCodeAdiv2" class="popupdiv divpopup-layer-package">
       <div class="popupdivWrapper" style="width: 700px;">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('corpCodeAdiv');" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">RMP회사코드 검색</h3>
                </div>
                <div class="search-div">
                    <input type="text" class="text-code" placeholder="판매사명을 입력하세요" style="width:300px">
                    <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="검색">                        
                </div>
                <div class="code-div divpopup-layer-conts" style="overflow-y:hidden">
                    <table class="tbl_main tbl_popup">
                        <thead>
                            <tr>
                                <th>선택</th>
                                <th>RMP 회사구분코드</th>
                                <th>RMP 회사구분명</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="3" class="text-center">리스트가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                    <%--페이징처리--%>
                    <div class="page_wrap">
                         <div id="pagination2" class="page_curl" style="display:inline-block">
                             <div class="paginationjs">
                                 <div class="paginationjs-pages">
                                     <ul>
                                         <li class="paginationjs-prev disabled" style="padding-right:3px">
                                             <a><img src="../../Images/left-arrow.jpg" style="vertical-align:middle; height:100%; cursor:pointer" onmouseover="this.src=&quot;../../Images/left-arrow-hover.jpg&quot;" onmouseout="this.src=&quot;../../Images/left-arrow.jpg&quot;"></a>
                                         </li>
                                         <li class="paginationjs-page J-paginationjs-page active" data-num="1">
                                             <a>1</a>
                                         </li>
                                         <li class="paginationjs-page J-paginationjs-page" data-num="2">
                                             <a>2</a>
                                         </li>
                                         <li class="paginationjs-next J-paginationjs-next" data-num="2" title="Next page" style="padding-left:3px">
                                             <a><img src="../../Images/right-arrow.jpg" style="vertical-align:middle; height:100%; cursor:pointer" onmouseover="this.src=&quot;../../Images/right-arrow-hover.jpg&quot;" onmouseout="this.src=&quot;../../Images/right-arrow.jpg&quot;"></a>
                                         </li>
                                     </ul>
                                </div>
                          </div>
                     </div> 
                 </div>
                </div>
                <div class="btn_center">
                    <input type="button" id="btnCancel2" class="mainbtn type2" style="width:75px" value="취소" onclick="fnClosePopup('corpCodeAdiv2'); return false;" />
                    <input type="button" id="btnOk2" class="mainbtn type1" style="width:75px" value="확인" onclick="fnClosePopup('corpCodeAdiv2'); return false;" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>
