<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CompanyLinkManagement.aspx.cs" Inherits="Admin_Company_CompanyLinkManagement" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <link href="../Content/Goods/goods.css" rel="stylesheet" />

    <style>
     
    </style>
    <script type="text/javascript">



        $(document).on('click', '#tblHeader td:not(:nth-child(9))', function () {
            alert('연동 수정 기능 개선 중 입니다.')
            // fnShowDetail(this); return false;
        });



        $(document).ready(function () {
            $('#<%= txtLinkCode.ClientID%>').val('');
            $('#<%= txtLinkName.ClientID%>').val('');
            $('#<%= txtSaleCompCode.ClientID%>').val('');
            $('#<%= txtBuyCompCode.ClientID%>').val('');
            $('#<%= txtSearchSdate.ClientID%>').val('');
            $('#<%= txtSearchEdate.ClientID%>').val('');
            $('#<%= txtRemark.ClientID%>').val('');

        });

        $(function () {
            var tableid = 'tbSocialCompanyList';
            var tableidUpdate = 'tbSocialCompanyListUpdate';
            ListCheckboxOnlyOne(tableid); //체크박스 하나만 체크되게..
            ListCheckboxOnlyOne(tableidUpdate); //체크박스 하나만 체크되게..
        });

        function fnCodeGenerate() {
            var callback = function (response) {
                $('#<%= txtLinkCode.ClientID%>').val(response);
                $('#<%= hfLinkCode.ClientID%>').val(response); //textBox가 readOnly 이기 때문에 히든필드에 저장
                return false;
            }
            var param = { Type: 'SocialCompanyLink' };

            //jquery Ajax function 호출 (type, url, data, responseDataType, callback)
            Jajax('Post', '../../Handler/Common/CodeGenerateHandler.ashx', param, 'text', callback);
        }

        //등록 시 빈 값이 있나 체크하는 함수.
        function fnValidate() {
            var hfLinkCode = $('#<%= hfLinkCode.ClientID%>');
            var txtLinkCode = $('#<%= txtLinkCode.ClientID%>');
            var txtLinkName = $('#<%= txtLinkName.ClientID%>');
            var txtSaleCompCode = $('#<%= txtSaleCompCode.ClientID%>');
            var txtBuyCompCode = $('#<%= txtBuyCompCode.ClientID%>');
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

                //var e = document.getElementById('corpCodeAdiv');

                //if (e.style.display == 'block') {
                //    e.style.display = 'none';

                //} else {
                //    e.style.display = 'block';
                //}
                return false;
            }

            var param = { Method: 'SocialCompanyList', Gubun: gubun };

            //jquery Ajax function 호출 (type, url, data, responseDataType, callback)
            Jajax('Post', '../../Handler/Admin/SocialCompanyHandler.ashx', param, 'json', callback);
        }

        function fnSelectCompany() {
            $('#tbSocialCompanyList input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    //var test1 = $(this).parent().next('td').html();
                    //var test2 = $(this).parent().next('td').next('td').html();

                    var code = $(this).next('input').val();
                    var name = $(this).next('input').next('input').val();

                    if ($('#hfGubun').val() == 'SU') {
                        $('#<%= txtSaleCompCode.ClientID%>').val(code);
                        $('#<%= hfSaleCompCode.ClientID%>').val(code); //textBox가 readOnly 이기 때문에 히든필드에 저장
                    }
                    else if ($('#hfGubun').val() == 'BU') {
                        $('#<%= txtBuyCompCode.ClientID%>').val(code);
                        $('#<%= hfBuyCompCode.ClientID%>').val(code); //textBox가 readOnly 이기 때문에 히든필드에 저장
                    }

                }
            });

            $('.divpopup-layer-package').fadeOut();
        }
        function fnEnter() {

            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnSearch)%>
                return false;
            }
            else
                return true;
        }
        function fnEnterKey() {

            if (event.keyCode == 13) {

                return false;
            }
            else
                return true;
        }


        function fnDeleteConfirm() {
            if (confirm('삭제 하시겠습니까?')) {
                return true;
            }
            return false;
        }

        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }


        //시퀀스 체크
        function fnSeqChk() {
            var seq = $('#<%= txtSeq.ClientID%>').val();
            var chkCompanyCode = $('#<%= txtBuyCompCode.ClientID%>').val();
            var chkSaleCompanyCode = $('#<%= txtSaleCompCode.ClientID%>').val();
            var plusSeq = '1';
            var txtSaleCompCode = $('#<%= txtSaleCompCode.ClientID%>');
            var txtBuyCompCode = $('#<%= txtBuyCompCode.ClientID%>');

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
                        $('#<%= txtSeq.ClientID%>').val(seq);
                    }
                    fnOverlapChk(chkCompanyCode, chkSaleCompanyCode);
                    //alert('순번 체크가 완료되었습니다.')
                    //$("#hdSeqChk").val(1);
                });

                return false;
            }

            var param = { Method: 'SocialCompanyChkSeq', Seq: seq, ChkCompanyCode: chkCompanyCode };

            Jajax('Post', '../../Handler/Admin/SocialCompanyHandler.ashx', param, 'json', callback);

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
                        $('#<%= txtSeq.ClientID%>').val(1);
                    }
                    else {

                        alert('순번 체크가 완료되었습니다.')
                        $("#hdSeqChk").val(1);           // //hdSeqChk 값이 0이면 저장할 수 있음.
                    }

                });

                return false;
            }

            var param = { Method: 'SocialCompanyChkCom', ChkCompanyCode: CompanyCode, ChkSaleCompanyCode: SaleCompanyCode };

            Jajax('Post', '../../Handler/Admin/SocialCompanyHandler.ashx', param, 'json', callback);


        }


        //팝업창 관계사 연동 순번 체크
        function fnSchSeq() {
            var seq = $('#<%= LinkSeq.ClientID%>').val();
            var hdLinkSeq = $('#<%= hdLinkSeq.ClientID%>').val();
            var chkCompanyCode = $('#<%= BuyComCode.ClientID%>').val();
            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        if (hdLinkSeq == value.SocialComapnyLinkSeq) {
                            alert('변경 된 값이 없습니다.')
                            return false;
                        }

                        if (confirm('관계사 연동 순번이 중복됩니다. 변경하시겠습니까?')) {
                            $('#<%= LinkSeq.ClientID%>').val(value.SocialComapnyLinkSeq);
                        } else {
                            $('#<%= LinkSeq.ClientID%>').val(hdLinkSeq);
                        }

                    });
                }
                else {
                    alert('중복 값이 없습니다.')
                }


                return false;
            }

            var param = { Method: 'SocialCompanySelect', Seq: seq, ChkCompanyCode: chkCompanyCode };

            Jajax('Post', '../../Handler/Admin/SocialCompanyHandler.ashx', param, 'json', callback);

        }

        //수정 창에 값 전달하는 함수
        function fnShowDetail(el) {
            $("select[name='selectedSeq'] option").remove();

            $('#<%= ComName.ClientID%>').val('');
            $('#<%= SaleComCode.ClientID%>').val('');
            $('#<%= BuyComCode.ClientID%>').val('');
            $('#<%= LinkSeq.ClientID%>').val('');
            $('#<%= Remark.ClientID%>').val('');
            $('#<%= hdLinkSeq.ClientID%>').val('');
            $('#<%= LinkCode.ClientID%>').val('');

            var ComName = $(el).parent().find('#tdComName').text().trim();
            var SaleComCode = $(el).parent().find('#tdSaleComCode').text().trim();
            var BuyComCode = $(el).parent().find('#tdBuyComCode').text().trim();
            var LinkSeq = $(el).parent().find('#tdLinkSeq').text().trim();
            var Remark = $(el).parent().find('#tdRemark').text().trim();
            var hdLinkSeq = $(el).parent().find('#tdLinkSeq').text().trim();
            var LinkCode = $(el).parent().find('#tdLinkCode').text().trim();


            $('#<%= ComName.ClientID%>').val(ComName);
            $('#<%= SaleComCode.ClientID%>').val(SaleComCode);
            $('#<%= BuyComCode.ClientID%>').val(BuyComCode);
            $('#<%= LinkSeq.ClientID%>').val(LinkSeq);
            $('#<%= Remark.ClientID%>').val(Remark);
            $('#<%= hdLinkSeq.ClientID%>').val(hdLinkSeq);
            $('#<%= LinkCode.ClientID%>').val(LinkCode);



            //var callback = function (response) {

            //    $.each(response, function (key, value) {

            //        $("#selectedSeq").prepend("<option value='0'>" + value.SocialComapnyLinkSeq + "</option>");
            //        //여기다가 select 쪽 

            //    });

            //    return false;
            //}

            //var param = { Method: 'SocialCompanySelect', ChkCompanyCode: BuyComCode };

            //Jajax('Post', '../../Handler/Admin/SocialCompanyHandler.ashx', param, 'json', callback);

            
            fnOpenDivLayerPopup('PGdiv');
            //var e = document.getElementById('PGdiv');
            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}
            return false;
        }


        //수정팝업에서 조회
        function fnComBuyerSearchPopup(gubun) {

            if (gubun == 'SU') {
                $('#lblDialogName').text('판매사 회사구분코드');
                $('#lblHeaderCodeUpdate').text('판매사 회사구분코드');
                $('#lblHeaderNameUpdate').text('판매사 회사구분명');
                $('#imgTitleUpdate').attr('src', '../Images/Member/a-title.jpg')
            }
            else if (gubun == 'BU') {
                $('#lblDialogName').text('구매사 회사구분코드');
                $('#lblHeaderCodeUpdate').text('구매사 회사구분코드');
                $('#lblHeaderNameUpdate').text('구매사 회사구분명');
                $('#imgTitleUpdate').attr('src', '../Images/Member/b-title.jpg')
            }

            $('#hfGubunUpdate').val(gubun);

            var callback = function (response) {

                $('#tbSocialCompanyListUpdate').find('tr:gt(0)').remove(); //테이블 클리어
                var index = 0;
                $.each(response, function (key, value) { //테이블 추가
                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfCompCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hfCompName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
                    newRowContent += "<td> " + value.SocialCompany_Code + " </td><td>" + value.SocialCompany_Name + "</td></tr>";
                    $('#tbSocialCompanyListUpdate tr:last').after(newRowContent);

                    index++;
                });

                var e = document.getElementById('corpCodeAdivUpdate');

                if (e.style.display == 'block') {
                    e.style.display = 'none';

                } else {
                    e.style.display = 'block';
                }
                return false;
            }

            var param = { Method: 'SocialCompanyList', Gubun: gubun };

            //jquery Ajax function 호출 (type, url, data, responseDataType, callback)
            Jajax('Post', '../../Handler/Admin/SocialCompanyHandler.ashx', param, 'json', callback);
        }

        //수정팝업에서 조회
        function fnSelectCompanyUpdate() {
            $('#tbSocialCompanyListUpdate input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    //var test1 = $(this).parent().next('td').html();
                    //var test2 = $(this).parent().next('td').next('td').html();

                    var code = $(this).next('input').val();
                    var name = $(this).next('input').next('input').val();

                    if ($('#hfGubunUpdate').val() == 'SU') {
                        $('#<%= SaleComCode.ClientID%>').val(code);
                     <%--   $('#<%= hfSaleCompCode.ClientID%>').val(code); //textBox가 readOnly 이기 때문에 히든필드에 저장--%>
                    }
                    else if ($('#hfGubunUpdate').val() == 'BU') {
                        $('#<%= BuyComCode.ClientID%>').val(code);
                     <%--   $('#<%= hfBuyCompCode.ClientID%>').val(code); //textBox가 readOnly 이기 때문에 히든필드에 저장--%>
                    }

                }
            });

            $('#corpCodeAdivUpdate').fadeOut();
        }


        function fnCancelUpdate() {

            $('#corpCodeAdivUpdate').fadeOut();
        }
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
         
                <div class="sub-title-div">
                    <p class="p-title-mainsentence">
                        관계사 연동관리
                    <span class="span-title-subsentence"></span>
                    </p>
                </div>
          
            <div>

                <br />
                <div>
                    <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="PG 관리" onclick="fnGoPage('PG')" />
                    <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="주문 연동 관리" onclick="fnGoPage('OBM')" />
                    <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="여신 관리" onclick="fnGoPage('LOAN')" />
                </div>
                <div class="bottom-search-div">
                    <table class="tbl_search">
                        <tr>
                            <td style="width:80px;"></td>
                            <td>
                                <asp:TextBox runat="server" ID="txtSearchLinkName" placeholder="회사연동명으로 검색" Width="700px" Onkeypress="return fnEnter();"></asp:TextBox>
                                <asp:Button runat="server" ID="btnSearch" OnClick="btnSearch_Click" Text="검 색" style="width:75px;" CssClass="mainbtn type1" />
                            </td>
                        </tr>
                    </table>
                </div>
                <!--데이터 리스트 시작 -->
                <asp:ListView ID="lvCompanyLinkList" runat="server" ItemPlaceholderID="phItemList" OnItemCommand="lvCompanyLinkList_ItemCommand" OnItemDeleting="lvCompanyLinkList_ItemDeleting">
                    <LayoutTemplate>
                        <table id="tblHeader" class="tbl_main">
                            <colgroup class="">
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                            </colgroup>
                            <thead>
                                <tr class="board-tr-height">
                                    <th class="txt-center">번호</th>
                                    <th class="txt-center">회사연동코드</th>
                                    <th class="txt-center">회사연동명</th>
                                    <th class="txt-center">판매사 회사구분코드</th>
                                    <th class="txt-center">구매사 회사구분코드</th>
                                    <th class="txt-center">관계사 연동 순번</th>
                                    <th class="txt-center">비고</th>
                                    <th class="txt-center">등록날짜</th>
                                    <th class="txt-center">삭제</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:PlaceHolder ID="phItemList" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr class="board-tr-height">
                            <td class="txt-center">
                                <%# Container.DataItemIndex + 1%>
                            </td>
                            <td class="txt-center" id="tdLinkCode">
                                <%# Eval("SocialCompanyLink_Code").ToString()%>
                            </td>
                            <td class="txt-center" id="tdComName">
                                <%# Eval("SocialCompanyLink_Name").ToString()%>
                            </td>
                            <td class="txt-center" id="tdSaleComCode">
                                <%# Eval("SaleSocialCompany_Code").ToString()%>
                            </td>
                            <td class="txt-center" id="tdBuyComCode">
                                <%# Eval("BuySocialCompany_Code").ToString()%>
                            </td>
                            <td class="txt-center" id="tdLinkSeq">
                                <%# Eval("SocialCompanyLinkSeq").ToString()%>
                            </td>
                            <td class="txt-center" id="tdRemark">
                                <%# Eval("Remark").ToString()%>
                            </td>
                            <td class="txt-center">
                                <%# ((DateTime)(Eval("EntryDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                            <td class="txt-center">
                                <asp:Button runat="server" ID="deleteLink" Text="삭제" OnClientClick="return fnDeleteConfirm();" CommandArgument='<%# Eval("SOCIALCOMPANYLINK_CODE").ToString() %>' CommandName="Delete" />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <table class="board-table">
                            <colgroup>
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                            </colgroup>
                            <thead>
                                <tr class="board-tr-height">
                                    <th class="txt-center">번호</th>
                                    <th class="txt-center">회사연동코드</th>
                                    <th class="txt-center">회사연동명</th>
                                    <th class="txt-center">판매사 회사구분코드</th>
                                    <th class="txt-center">구매사 회사구분코드</th>
                                    <th class="txt-center">비고</th>
                                    <th class="txt-center">등록날짜</th>
                                    <th class="txt-center">삭제</th>
                                </tr>
                            </thead>
                            <tr class="board-tr-height">
                                <td colspan="8" style="text-align: center;">조회된 데이터가 없습니다.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>
                <!--데이터 리스트 종료 -->
                <!--페이징-->
                <div style="margin:0 auto; text-align:center">
                <ucPager:ListPager id="ucListPager" runat ="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20"/>
            </div>
                <!--페이징 끝-->
            </div>

            <div>

                <table id="tblInsert" class="tbl_main">
                    <tr>
                        <th>회사연동코드
                        </th>
                        <td>
                            <asp:TextBox runat="server" ID="txtLinkCode" OnkeyPress="return fnEnterKey();"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="hfLinkCode" />
                        </td>
                        <th>회사연동명
                        </th>
                        <td>
                            <asp:TextBox runat="server" ID="txtLinkName" OnkeyPress="return fnEnterKey();"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>판매사 회사구분코드
                        </th>
                        <td style="vertical-align: central">
                            <asp:TextBox runat="server" ID="txtSaleCompCode" ReadOnly="true" style="width:80%"></asp:TextBox>
                           <input type="button" class="mainbtn type1" style="width:75px; height: 30px; font-size: 12px" value="검색" onclick="fnSearchCompany('SU')"  />

                            <asp:HiddenField runat="server" ID="hfSaleCompCode" />
                        </td>


                        <th>구매사 회사구분코드
                        </th>
                        <td>
                            <asp:TextBox runat="server" ID="txtBuyCompCode" ReadOnly="true" style="width:80%"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="hfBuyCompCode" />
                            <%--                            <asp:ImageButton runat="server" ID="btnSearchBuy" OnClientClick="fnSearchCompany('B'); return false;" ImageUrl="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" />--%>
                           <input type="button" class="mainbtn type1" style="width: 75px; height: 30px; font-size: 12px" value="검색" onclick="fnSearchCompany('BU')"  />

                        </td>
                    </tr>
                    <tr>
                        <th>관계사 연동 순번</th>
                        <td colspan="3">
                            <asp:TextBox runat="server" ReadOnly="true" ID="txtSeq" Width="38%" value="1"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="hdSeq" />
                            <input type="button" class="mainbtn type1" id="btnSeqChk" name="btnSeqChk" value="순번체크" onclick="return fnSeqChk();" />
                            <input type="hidden" id="hdSeqChk" name="hdSeqChk" value="0" />
                        </td>
                    </tr>
                    <tr>
                        <th>관계사 연동 시작일</th>
                        <td>
                            <asp:TextBox ID="txtSearchSdate" runat="server" MaxLength="10" CssClass="calendar" OnkeyPress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                        </td>
                        <th>관계사 연동 종료일 </th>
                        <td>
                            <asp:TextBox ID="txtSearchEdate" runat="server" MaxLength="10" CssClass="calendar" OnkeyPress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <th>비고
                        </th>
                        <td colspan="3">
                            <asp:TextBox runat="server" ID="txtRemark" Width="90%" OnkeyPress="return fnEnterKey();"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <br />
                <div>
                    <asp:Button runat="server" ID="btnCodeGenerate" OnClientClick="fnCodeGenerate(); return false;" Text="연동코드생성" CssClass="mainbtn type1"/>
                    <asp:Button runat="server" ID="ibtnSave" OnClick="ibtnSave_Click" OnClientClick="return fnValidate();" Text="등록" CssClass="mainbtn type1" />
                </div>
            </div>
        </div>
    </div>




    <div id="PGdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnCancel()" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <div class="sub-title-div">
                    <p class="p-title-mainsentence">
                        <img src="../Images/title-img.jpg" class="img-title" />관계사 연동 수정
         
                    </p>
                </div>


                <div class="popup-title" style="margin-top: 20px;">

                    <table class="pgTblPop">

                        <tr>
                            <th>연동코드</th>
                            <td>
                                <asp:TextBox runat="server" ReadOnly="true" ID="LinkCode"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>회사연동명</th>
                            <td>
                                <asp:TextBox runat="server" ID="ComName"></asp:TextBox>
                            </td>
                        </tr>

                        <tr>
                            <th>판매사 회사 구분코드</th>
                            <td>
                                <asp:TextBox runat="server" ID="SaleComCode"></asp:TextBox>

                                <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" onclick="fnComBuyerSearchPopup('A')" />

                            </td>
                        </tr>

                        <tr>
                            <th>구매사 회사 구분코드</th>
                            <td>
                                <asp:TextBox runat="server" ID="BuyComCode"></asp:TextBox>
                                <a>
                                    <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" onclick="fnComBuyerSearchPopup('B')" /></a>

                            </td>
                        </tr>

                        <tr>
                            <th>관계사 연동 순번</th>
                            <td>
                                <%--   <select id="selectedSeq" name="selectedSeq" style="width: 50%">
                                </select>--%>
                                <asp:TextBox runat="server" ID="LinkSeq"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="hdLinkSeq" />
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
                        <asp:ImageButton runat="server" ID="btnSave" OnClick="click_save" ImageUrl="../Images/Member/save.jpg" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'" />
                    </div>

                </div>
            </div>
        </div>
    </div>


    <%--코드 검색 Popup 창 시작--%>
    <div id="corpCodeAdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper">
            <div class="popupdivContents">



                <div class="popup-title" style="margin-top: 20px;">
                    <img id="imgTitle" src="../Images/Member/a-title.jpg" alt="회사구분코드검색" />
                </div>
                <div class="code-div" style="height: 340px">
                    <%--이부분은 동적으로 생성되는 테이블이니까 자바스크립트 fnSearchCompany 함수 참고하시고 그부분에서 수정해주세요--%>
                    <table id="tbSocialCompanyList" class="tblCode">
                        <thead>
                            <tr>
                                <th>선택
                                </th>
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
                <br />
                <div style="text-align: right">
                    <input type="button" id="btnOk" value="확인" onclick="fnSelectCompany(); return false;" />
                    <input type="button" id="btnCancel" value="취소" onclick="fnCancel(); return false;" />
                    <input type="hidden" id="hfGubun" value="None" />
                </div>
            </div>
        </div>
    </div>

    <%--코드 검색 Popup 창 끝--%>


    <%--코드 검색 Popup 창 시작--%>
    <div id="corpCodeAdivUpdate" class="divpopup-layer-package">
        <div class="corpCodeAwrapper">
            <div class="corpCodeAcontents">



                <div class="popup-title" style="margin-top: 20px;">
                    <img id="imgTitleUpdate" src="../Images/Member/a-title.jpg" alt="회사구분코드검색" />
                </div>
                <div class="code-div" style="height: 340px">
                    <%--이부분은 동적으로 생성되는 테이블이니까 자바스크립트 fnSearchCompany 함수 참고하시고 그부분에서 수정해주세요--%>
                    <table id="tbSocialCompanyListUpdate" class="tblCode">
                        <thead>
                            <tr>
                                <th>선택
                                </th>
                                <th>
                                    <label id="lblHeaderCodeUpdate"></label>
                                </th>
                                <th>
                                    <label id="lblHeaderNameUpdate"></label>
                                </th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <br />
                <div style="text-align: right">
                    <input type="button" id="btnOkUpdate" value="확인" onclick="fnSelectCompanyUpdate(); return false;" />
                    <input type="button" id="btnCancelUpdate" value="취소" onclick="fnCancelUpdate(); return false;" />
                    <input type="hidden" id="hfGubunUpdate" value="None" />
                </div>
            </div>
        </div>
    </div>

    <%--코드 검색 Popup 창 끝--%>
</asp:Content>

