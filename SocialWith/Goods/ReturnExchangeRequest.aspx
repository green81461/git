<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="ReturnExchangeRequest.aspx.cs" Inherits="Goods_ReturnExchangeRequest" %>
<%@ Import Namespace="Urian.Core" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        /* Style the tab */
        div.tab {
            overflow: hidden;
        }
		.board-table th{border:1px solid #a2a2a2 }

        /* Create an active/current tablink class */
        .tabButton.active {
            background-color: #ccc;
        }

        /*소스용 css - 수정,삭제 불가!!*/
        .tab-display {}

        /* 임시용 */
        #tblHeader th, #tblHeader td {
            border: 1px solid #929292;
        }
        .imgStyle{      
            margin-left: 10px;
        }
    </style>
    <script type="text/javascript">
        var is_sending = false;

        $(document).ready(function () {
            //fnOpenTab("btnTab1", "requestDiv", 'load');

            // 구분 selectbox 변경이벤트
            $("#sboxGubun").on("change", function () {
                $("#sboxGubun option:selected").each(function () {
                    var gubun = $(this).val();
                    fnSelectBoxGubunChange(gubun); // 구분값에 따라 유형 selectbox 변경
                });
            });

            $("#sboxTypeEx").on("change", function () {
                $("#sboxTypeEx option:selected").each(function () {
                    var cost = $(this).attr("cost");
                    fnDeliveryCostSet(cost); // 구분값에 따라 유형 selectbox 변경
                });
            });

            $("#sboxTypeRe").on("change", function () {
                $("#sboxTypeRe option:selected").each(function () {
                    var cost = $(this).attr("cost");
                    fnDeliveryCostSet(cost); // 구분값에 따라 유형 selectbox 변경
                });
            });

            // 팝업 화면에서 신청 버튼 클릭 시
            $("#btnRequest").on("click", function () {
                var max = 50;
                var inputNum = $("#inputRtnChgQty").val();

                if ((inputNum == "") || (inputNum < 1)) {
                    alert("수량에 0보다 큰 값을 입력해 주세요.");
                    return false;
                }

                if (inputNum > max) {
                    alert("구매하신 수량보다 큰 값은 입력하실 수 없습니다.");
                    return false;
                }

                fnSaveRequest();
            });
        });

        // 반품/교환 수량 입력창 관련 기능
        $(document).on("blur", "input[id^=inputRtnChgQty]", function () {
            //var gdsUnitMoq = $("#hdGdsUnitMoq").val();
            var inputQty = Number($("#inputRtnChgQty").val());
            var userQty = Number($("#hdUserQty").val());

            if (!isEmpty(inputQty)) {
                //if ((inputQty % gdsUnitMoq) != 0) {
                //    alert("최소수량인 '" + gdsUnitMoq + "' 의 배수로 입력하셔야 합니다.");
                //    $("#inputRtnChgQty").val('');
                //    $("#inputRtnChgQty").focus();
                //    return false;
                //}

                if (inputQty > userQty) {
                    alert("구매하신 수량보다 큰 값을 입력하실 수 없습니다.");
                    $("#inputRtnChgQty").val("");
                    $("#inputRtnChgQty").focus();
                    return false;
                }
            }
            
            var salePrice = $("#hdSalePriceVat").val();
            var rtnChgPrice = inputQty * salePrice;

            $("#sp_chgPrice").text(numberWithCommas(rtnChgPrice) + " 원");
        });

        // 팝업에서 신청 버튼 클릭 시
        function fnSaveRequest() {
            var sboxGugun = $("#sboxGubun").val();
            var gdsRtnChgFlag = $("#hdGdsRtnChgFlag").val();

            if (gdsRtnChgFlag != "1") {
                if ((sboxGugun == "15") && (gdsRtnChgFlag == "3")) { // 교환
                    alert("교환불가 상품입니다. 교환하실 수 없습니다.");
                    return false;
                } else if ((sboxGugun == "14") && (gdsRtnChgFlag == "2")) { // 반품
                    alert("반품불가 상품입니다. 반품하실 수 없습니다.");
                    return false;
                }
            }

            var qty = Number($("#sp_qty").text());              // 주문수량
            var inputQty = Number($("#inputRtnChgQty").val());  // 반품/교환 수량
            var dbNoRtnQty = Number($("#hdNoRtnQty").val());    // 기존 반품/교환 수량
            var remainNoRtnQty = qty - inputQty;                // 남은 반품/교환 가능 수량
            var newNoRtnQty = inputQty + dbNoRtnQty;            // 새로 저장될 반품/교환 수량
            
            //if ((sboxGugun == "14") && (inputQty > qty)) {
            if (inputQty > qty) {
                alert("입력하신 수량값이 반품/교환 신청이 가능한 수량을 초과하였습니다.");
                return false;
            }
            
            var rtnChgType = "";

            if (sboxGugun == "15") {
                rtnChgType = $("#sboxTypeEx").val();
            } else if (sboxGugun == "14") {
                rtnChgType = $("#sboxTypeRe").val();
            }
            
            var salePrice = $("#hdSalePriceVat").val();
            var rtnChgPrice = inputQty * salePrice; // 반품 금액 계산 시 배송비는 제외한 값

            var uOrderNo = $("#hdUnumOrderNo").val();
            var gubun = $("#hdGubun").val();
            var deliGubun = $("#hdRtnChgDeliGubun").val();

            var orderCodeNo = $("#hOrderCodeNo").val();
            var gdsFinCtgrCode = $("#hdGdsFinCtgrCode").val();
            var gdsGrpCode = $("#hdGdeGrpCode").val();
            var gdsCode = $("#hdGdsCode").val();

            var callback = function (response) {

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        if (value == "OK") {
                            alert("반품/교환이 신청되었습니다.");

                            window.location.href = "ReturnExchangeRequest.aspx";
                        }

                        fnCancel('divpopupRetExcReq');
                    });
                } else {
                    alert("오류가 발생했습니다. 관리자에게 문의하시기 바랍니다.");
                    return false;
                }
                return false;
            };

            var svidUser = '<%= Svid_User%>';
            var param = {
                Unum_OrderNo: uOrderNo, Svid_User: svidUser, Gubun: gubun, RtnChgGubun: sboxGugun, RtnChgDeliGubun: deliGubun
                , RtnChgType: rtnChgType, Qty: remainNoRtnQty, RtnChgQty: inputQty, RtnChgPrice: rtnChgPrice, NoReturnQty: newNoRtnQty
                , OrderCodeNo: orderCodeNo, GdsFinCtgrCode: gdsFinCtgrCode, GdsGrpCode: gdsGrpCode, GdsCode: gdsCode, Flag: "RtnChgReq"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;
            
            JajaxDuplicationCheck("Post", "../Handler/ReturnExchangeHandler.ashx", param, "json", callback, beforeSend, complete, true, '<%= Svid_User %>');
        }

        // 탭 기능
        //function fnOpenTab(tabBtnId, tabContentId, page) {
        //    $(".tab-display").css("display", "none");
        //    $(".tablinks").removeClass("active");

        //    $("#" + tabContentId).css("display", "block");
        //    $("#" + tabBtnId).addClass("active");
           

        //    if (page == "load") {
                

        //    } else if ((page != "") && (page != "load")) {
        //        $("#" + tabContentId).load(page);
                
        //    } else if (page == "") {
        //        location.reload();
        //    }
        //}

        // 팝업창에 주문정보 설정
        function fnSetOrderInfo(orderInfo) {

            if ((orderInfo == null) || (orderInfo.length < 1)) {
                alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                return false;
            }

            var tmpOrderDate = orderInfo[0].EntryDate;
            tmpOrderDate = tmpOrderDate.split("T");

            var tmpGdsInfo = '[' + orderInfo[0].BrandName + "] " + orderInfo[0].GoodsFinalName + "<br>" + orderInfo[0].GoodsOptionSummaryValues;

            $("#sp_orderNo").text(orderInfo[0].OrderCodeNo);
            $("#sp_orderDate").text(tmpOrderDate[0]);
            $("#sp_saleCompNm").text(orderInfo[0].SaleCompany_Name);
            $("#sp_gdsInfo").html(tmpGdsInfo);
            $("#sp_model").text(orderInfo[0].GoodsModel);
            $("#sp_salePrice").text(numberWithCommas(orderInfo[0].GoodsSalePriceVat * orderInfo[0].Qty) + " 원");
            $("#sp_qty").text(orderInfo[0].Qty);

            $("#sp_gdsCode").text(orderInfo[0].GoodsCode);
            $("#sp_gdsUnit").text(orderInfo[0].GoodsUnit_Name);
            $("#sp_ordStat").text(orderInfo[0].OrderStatus_NAME);
            var dlvrDate = "";
            if (!isEmpty(orderInfo[0].DeliveryDate)) {
                dlvrDate = orderInfo[0].DeliveryDate.split("T")[0];
            }
            $("#sp_dlvrDate").text(dlvrDate);
            
            $("#hdSvidUser").val(orderInfo[0].Svid_User);
            $("#hdUnumOrderNo").val(orderInfo[0].Unum_OrderNo);
            $("#hdGubun").val(orderInfo[0].Gubun);
            $("#hdRtnChgDeliGubun").val('');
            $("#hdUserQty").val(orderInfo[0].Qty);
            $("#hdGdsUnitMoq").val(orderInfo[0].GoodsUnitMoq);
            $("#hdGdsUnitQty").val(orderInfo[0].GoodsUnitQty);
            $("#hdGdsUnitNm").val(orderInfo[0].GoodsUnit_Name);
            $("#hdSalePriceVat").val(orderInfo[0].GoodsSalePriceVat);
            $("#hdGdsRtnChgFlag").val(orderInfo[0].GoodsReturnChangeFlag);

            $("#hOrderCodeNo").val(orderInfo[0].OrderCodeNo);
            $("#hdGdsFinCtgrCode").val(orderInfo[0].GoodsFinalCategoryCode);
            $("#hdGdeGrpCode").val(orderInfo[0].GoodsGroupCode);
            $("#hdGdsCode").val(orderInfo[0].GoodsCode);
            $("#hdNoRtnQty").val(orderInfo[0].NoReturnQty);

        }

        // 팝업창에 구분, 유형 항목 설정
        function fnSetCommList(commList) {
            
            for (var item in commList) {
                //alert(item + " : " + ", " + commList[item].Map_Type);
                
                // 구분 selectbox
                if (commList[item].Map_Type == 0) {

                    var option = $("<option value=" + commList[item].Map_Channel + "></option>").text(commList[item].Map_Name);

                    if (commList[item].Map_Channel == 14) // 반품
                        $("#sboxGubun").append(option);

                    else if (commList[item].Map_Channel == 15) // 교환
                        $("#sboxGubun").prepend(option);
                    
                // 유형 selectbox
                } else {

                    var mapName = commList[item].Map_Name;
                    var cutMapName = mapName.substr(0, (mapName.length - 1));
                    var dCostCode = mapName.substr((mapName.length - 1), 1);

                    //var optionVal = commList[item].Map_Type + dCostCode;

                    var option = $("<option value=" + commList[item].Map_Type + " cost=" + dCostCode + "></option>").text(cutMapName);

                    if (commList[item].Map_Channel == 14) {

                        $("#sboxTypeRe").append(option);

                    } else if (commList[item].Map_Channel == 15) {
                        $("#sboxTypeEx").append(option);
                    }
                }
            }
            
            $("#sboxGubun option:eq(0)").prop("selected", true); // 기본값 교환으로 선택

            var commGubun = 15; // 구분 selectbox에서 교환값 저장 변수
            fnSelectBoxGubunChange(commGubun); // 구분값에 따라 유형 selectbox 변경
        }

        // 신청하기 버튼 클릭 시 팝업 띄움
        //function fnRequestPopup(clickId, divPopupId, popupBodyId) {
        function fnRequestPopup(clickId) {
            // ajax callback 함수
            var callback = function (response) {

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        switch (key) {
                            case "orderInfo":
                                fnSetOrderInfo(value);
                                break;
                            case "commList":
                                fnSetCommList(value);
                                break;
                            default:
                                alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                                break;
                        }

                    });
                } else {
                    alert("오류가 발생했습니다. 관리자에게 문의하시기 바랍니다.");
                    return false;
                }

                //var width = 800;
                //var height = 600;
                //var left = (window.innerWidth / 2) - (width / 2);
                //var top = (window.innerHeight / 2) - (height / 2);
                //layer_popup_open(divPopupId, popupBodyId, top / 2, left, width, height);
                var e = document.getElementById('returnExchangeDiv');

                if (e.style.display == 'block') {
                    e.style.display = 'none';

                } else {
                    e.style.display = 'block';
                }
            }
            
            var clickTr = $(clickId).parent().parent();

            var hdTr_unumOrderNo = $(clickTr).find("input:hidden[id*=hdTr_uNumOrderNo]").val();
            var hdTr_orderCodeNo = $(clickTr).find("input:hidden[id*=hdTr_orderCodeNo]").val();
            var hdTr_gdsFinCtgrCode = $(clickTr).find("input:hidden[id*=hdTr_gdsFinCtgrCode]").val();
            var hdTr_gdsGrpCode = $(clickTr).find("input:hidden[id*=hdTr_gdsGrpCode]").val();
            var hdTr_gdsCode = $(clickTr).find("input:hidden[id*=hdTr_gdsCode]").val();

            var svidUser = '<%= Svid_User%>';
            var param = {
                Unum_OrderNo: hdTr_unumOrderNo, OrderCodeNo: hdTr_orderCodeNo, GdsFinCtgrCode: hdTr_gdsFinCtgrCode, GdsGrpCode: hdTr_gdsGrpCode, GdsCode: hdTr_gdsCode
                , Svid_User: svidUser, MapCode: "GOODS", MapChanel_1: 14, MapChanel_2: 15, Flag: "OrderInfo"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JajaxDuplicationCheck("Post", "../Handler/ReturnExchangeHandler.ashx", param, "json", callback, beforeSend, complete, true, '<%= Svid_User %>');

            <%--JajaxSessionCheck("Post", "../Handler/ReturnExchangeHandler.ashx", param, "json", callback, '<%=Svid_User %>');--%> // ajax 호출

        }

        // 구분 selectbox 변경 시
        function fnSelectBoxGubunChange(commGubun) {

            $("#sboxTypeEx").hide();
            $("#sboxTypeRe").hide();

            var selectId = "#sboxTypeEx";

            if (commGubun == 14) { // 반품
                selectId = "#sboxTypeRe";
            } else if (commGubun == 15) { //c교환
                selectId = "#sboxTypeEx";
            }
            $(selectId + " option:eq(0)").prop("selected", true);
            $(selectId).show();

            var cost = $(selectId + " option:eq(0)").attr("cost");

            fnDeliveryCostSet(cost);
        }

        // 배송비 설정
        function fnDeliveryCostSet(costVal) {

            switch (costVal) {
                case "A":
                    $("#sp_dCost").text("착불");
                    $("#hdRtnChgDeliGubun").val("A");
                    break;
                case "B":
                    $("#sp_dCost").text("선불");
                    $("#hdRtnChgDeliGubun").val("B");
                    break;
                default:
                    $("#sp_dCost").text("--");
                    $("#hdRtnChgDeliGubun").val("");
            }
        }

        // 취소 버튼 클릭 시 팝업 닫기
        function fnCancel(divPopupId) {
            $("#sboxGubun").html("");
            $("#sboxTypeEx").html("");
            $("#sboxTypeRe").html("");
            $("#inputRtnChgQty").val("");

            $(".divpopup-layer-package").fadeOut();
        }

        function fnRtnChgEnter() {
            
            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnSearch)%>
                return false;
            }
            else
                return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="sub-contents-div">
        <!--제목 타이틀-->
        <div class="sub-title-div">
          <img src="/images/exchangelist.png" />
        </div>
            <div class="tabHeaderWrap1" >
                 <a href='ReturnExchangeRequest.aspx' class='subTabOn' style="width:186px; height:35px;font-size:12px;">반품/교환 신청</a>
                 <a href='ReturnExchangeStatus.aspx' class='subTabOff' style="width:186px; height:35px;font-size:12px;">반품/교환 현황</a>
	         
            </div>
            <div class="clear"></div>
       
            <div id="requestDiv" class="tab-display">
                <div class="requestDiv-text" style="display: block; padding-top:10px">* 주의사항 : 배송완료일부터 7일 이내 반품/교환 신청이 가능합니다.</div>
                
<!--vat-->
                <span style="color:#69686d;  float:right;  margin-top:10px; padding-right:20px;margin-bottom:10px;"> *<b style="color:#ec2029; font-weight:bold;"> VAT(부가세)포함 가격</b>입니다.</span>
                <div style="margin-top:-30px">
                    <!--데이터 리스트 시작 -->
                    <asp:ListView ID="lvRequestList" runat="server" ItemPlaceholderID="phItemList">
                        <LayoutTemplate>

                            <table id="tblHeader" class="tbl_main">
                                <thead>
                                    <tr>
                                        <th class="text-center" >번호</th>
                                        <th class="text-center">주문날짜</th>
                                        <th class="text-center">주문번호</th>
                                        <th class="text-center">판매사</th>                
                                        <th class="text-center">상품정보</th>
                                        <th class="text-center">모델명</th>
                                        <th class="text-center">출하예정일</th>
                                        <th class="text-center">최소수량</th>
                                        <th class="text-center">내용량</th>
                                        <th class="text-center">상품금액</th>
                                        <th class="text-center">수량</th>
                                        <th class="text-center">배송완료일</th>
                                        <th class="text-center">결제현황</th>
                                        <th class="text-center">신 청</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:PlaceHolder ID="phItemList" runat="server" />
                                </tbody>
                            </table>
                        </LayoutTemplate>
                        <ItemTemplate>
                                <tr>

                                    <input type="hidden" id="hdTr_uNumOrderNo" value='<%# Eval("Unum_OrderNo").ToString()%>' />
                                    <input type="hidden" id="hdTr_orderCodeNo" value='<%# Eval("OrderCodeNo").ToString()%>' />
                                    <input type="hidden" id="hdTr_gdsFinCtgrCode" value='<%# Eval("GoodsFinalCategoryCode").ToString()%>' />
                                    <input type="hidden" id="hdTr_gdsGrpCode" value='<%# Eval("GoodsGroupCode").ToString()%>' />
                                    <input type="hidden" id="hdTr_gdsCode" value='<%# Eval("GoodsCode").ToString()%>' />

                                    <td class="txt-center">
                                        <%# Eval("Unum_OrderNo").ToString()%>
                                    </td>
                                    <td class="text-center">
                                        <%# ((DateTime)(Eval("EntryDate"))).ToString("yyyy-MM-dd")%>
                                    </td>
                                    <td class="txt-center">
                                        <%# Eval("OrderCodeNo").ToString()%>
                                    </td>
                                    <td class="txt-center">
                                        <%# Eval("SaleCompany_Name").ToString() %>
                                    </td>
                                   
                                    <td>
                                        <asp:Image runat="server" ID="imgGoods" Width="49" Height="50" ImageUrl='<%# String.Format("/GoodsImage/{0}/{1}/{2}/{3}", Eval("GoodsFinalCategoryCode") , Eval("GoodsGroupCode"), Eval("GoodsCode"), Eval("GoodsFinalCategoryCode").ToString() + "-" + Eval("GoodsGroupCode") + "-" + Eval("GoodsCode") + "-" + "sss.jpg")%>' onerror="this.onload = null; this.src='/Images/noImage_s.jpg';" CssClass="imgStyle" />
                                        <div style="float:right; width:80%">
                                        <span style="display:inline-block"><%# Eval("GoodsCode").ToString() %></span><br/>
                                        [<%# Eval("BrandName").ToString() %>]&nbsp;<%# Eval("GoodsFinalName").ToString() %><br /><span style="color:#368AFF"><%# Eval("GoodsOptionSummaryValues").ToString() %></span></div></td>
                                    <td class="txt-center">
                                        <%# Eval("GoodsModel").ToString() %>
                                    </td>
                                    <td class="txt-center">
                                        <%# Eval("GoodsDeliveryOrderDue_Name").ToString() %>
                                    </td>
                                    <td class="txt-center">
                                        <%# Eval("GoodsUnitMoq").ToString() %>
                                    </td>
                                    <td class="txt-center">
                                        <%# Eval("GoodsUnit_Name").ToString() %>
                                    </td>
                                    
                                    <td class="txt-center">
                                        <%# String.Format("{0:##,##0;}",Calculate(Eval("GoodsSalePriceVat").AsInt(), Eval("Qty").AsInt())) %> 원
                                    </td>
                                    <td class="txt-center">
                                        <%# Eval("Qty").ToString() %>
                                    </td>
                                    <td class="txt-center">
                                        <%# Eval("DeliveryDate") != null ?  Eval("DeliveryDate").AsDateTime().ToString("yyyy-MM-dd") :  ""%>
                                    </td>
                                    <td class="txt-center">
                                        <%# Eval("OrderStatus_NAME").ToString() %>
                                    </td>
                                    <td class="txt-center">    <%--신청버튼 있는곳--%>
                                        <%--<a onclick="fnRequestPopup(this,'divpopupRetExcReq','divPopup_retExcReq')" role="button"><img src="../Images/Goods/apply-on.jpg" alt="신청" onmouseover="this.src='../Images/Goods/apply-off.jpg'" onmouseout="this.src='../Images/Goods/apply-off.jpg'" /></a>--%>
                                        <input type='button' class='listBtn' value='신청' style='width:55px; height:22px; font-size:12px' onclick="fnRequestPopup(this)"/>
                                        <%--<a onclick="fnRequestPopup(this)" role="button"><img src="../Images/Goods/apply-on.jpg" alt="신청" onmouseover="this.src='../Images/Goods/apply-off.jpg'" onmouseout="this.src='../Images/Goods/apply-off.jpg'" /></a>--%>
                                    </td>
                                </tr>
                        </ItemTemplate>
                        <EmptyDataTemplate>
                            <table class="tbl_main" >
                                <thead>
                                    <tr class="board-tr-height" >
                                         <th class="text-center" >번호</th>
                                        <th class="text-center">주문날짜</th>
                                        <th class="text-center">주문번호</th>
                                        <th class="text-center">판매사</th>                
                                        <th class="text-center">상품정보</th>
                                        <th class="text-center">모델명</th>
                                        <th class="text-center">출하예정일</th>
                                        <th class="text-center">최소수량</th>
                                        <th class="text-center">내용량</th>
                                        <th class="text-center">상품금액</th>
                                        <th class="text-center">수량</th>
                                        <th class="text-center">배송완료일</th>
                                        <th class="text-center">결제현황</th>
                                        <th class="text-center">신 청</th>
                                    </tr>
                                </thead>
                                <tr class="board-tr-height">
                                    <td colspan="14" class="txt-center">조회된 데이터가 없습니다.</td>
                                </tr>
                            </table>
                        </EmptyDataTemplate>
                    </asp:ListView>
                    <!--데이터 리스트 종료 -->
            
                    <!--페이징-->
                    <div style="margin:0 auto; text-align:center">
                         <ucPager:ListPager id="ucListPager" runat ="server" PageSize="20" OnPageIndexChange="ucListPager_PageIndexChange"/>
                    </div>
                    <!--페이징 끝-->
                </div>

                <div class="bottom-search-div">
                    <table class="board-search-table">
                        <tr>
                            <td>
                                <asp:DropDownList ID="ddlSearchTarget" runat="server">
                                    <asp:ListItem Text="브랜드" Value="BRANDNAME"></asp:ListItem>
                                    <asp:ListItem Text="상품명" Value="GOODSFINALNAME"></asp:ListItem>
                                    <asp:ListItem Text="모델명" Value="GOODSMODEL"></asp:ListItem>
                                    <asp:ListItem Text="상품코드" Value="GOODSCODE"></asp:ListItem>
                                    <asp:ListItem Text="판매사명" Value="SALECOMPANY_NAME"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:TextBox ID="txtSearch" runat="server" Onkeypress="return fnRtnChgEnter();"  width="690px"></asp:TextBox>
                            </td>
                            <td style="width:95px; height:30px; float:left; margin-top:15px; margin-left:10px;">
                                <%--검색 버튼--%>
                               <%-- <asp:Button ID="btnSearch" runat="server" CssClass="board-search-btn" OnClick="btnSearch_Click"/>--%>
                                <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="검색" CssClass="mainbtn type1" Width="95" Height="30"/>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            
            <div id="statusDiv" class="tab-display">
                
                <%--<h3>반품/교환 현황</h3>--%>

            </div>
       
    </div>

    <%-- DIV 팝업창(신청하기) 시작 --%>
    <%-- <div id="divpopupRetExcReq" class="divpopup-layer-package">
        <div class="bg"></div>
        <div id="divPopup_retExcReq" class="divpopup-layer">--%>

    <div id="returnExchangeDiv" class="popupdiv divpopup-layer-package">
         <div class="popupdivWrapper" style="width:650px; height:500px">
            <div class="popupdivContents">
                <div class="divpopup-layer-conts">
                    <h3>반품/교환신청</h3>

                    <div id="selectRequestDiv">

                        <input type="hidden" id="hdUnumOrderNo" />
                        <input type="hidden" id="hdGubun" />
                        <input type="hidden" id="hdRtnChgDeliGubun" />
                        <input type="hidden" id="hdUserQty" />
                        <input type="hidden" id="hdGdsUnitMoq" />
                        <input type="hidden" id="hdGdsUnitQty" />
                        <input type="hidden" id="hdGdsUnitNm" />
                        <input type="hidden" id="hdSalePriceVat" />
                        <input type="hidden" id="hdGdsRtnChgFlag" />
                        <input type="hidden" id="hOrderCodeNo" />
                        <input type="hidden" id="hdGdsFinCtgrCode" />
                        <input type="hidden" id="hdGdeGrpCode" />
                        <input type="hidden" id="hdGdsCode" />
                        <input type="hidden" id="hdNoRtnQty" />

                        <%--<table id="tblReq_popup" >--%>
                        <table class="tbl_popup" >
                            <tr>
                                <th>구분</th>
                                    <td><select id="sboxGubun" style="width:50%;  height:80%;"></select></td>
                                <th>유형</th>
                                    <td><select id="sboxTypeEx" style="width:98%;  height:80%;"></select><select id="sboxTypeRe"></select></td>
                            </tr>
                             <tr>
                                  <th>판매사</th>
                                <td><span id="sp_saleCompNm"></span></td>
                                  <th>결제현황</th>
                                <td><span id="sp_ordStat"></span></td>
                            </tr>
                            <tr>
                                 <th>배송비</th>
                                    <td><span id="sp_dCost"></span></td>
                                 <th>배송완료일</th>
                                <td><span id="sp_dlvrDate"></span></td>
                            </tr>
                            <tr>
                                 <th>상품코드</th>
                                <td><span id="sp_gdsCode"></span></td>
                                 <th>모델명</th>
                                <td><span id="sp_model"></span></td>
                            </tr>
                            <tr>
                                <th>주문날짜</th>
                                <td><span id="sp_orderDate"></span></td>
                                <th>주문번호</th>
                                <td><span id="sp_orderNo"></span></td>
                            </tr>
                            <tr>
                                <th>상품정보</th>
                                <td><span id="sp_gdsInfo"></span></td>
                                <th>상품금액</th>
                                <td><span id="sp_salePrice"></span></td>
                            </tr>
                            <tr>
                                <th>내용량</th>
                                <td><span id="sp_gdsUnit"></span></td>
                                <th>주문수량</th>
                                <td><span id="sp_qty"></span></td>
                            </tr>
                            <tr>
                                <th>반품 금액</th>
                                <td ><span id="sp_chgPrice">---</span></td>
                                <th>반품/교환 수량</th>
                                <td><input type="number" id="inputRtnChgQty" min="0" max="9999999" style=" border:1px solid #a2a2a2; height:80%;"/></td>
                            </tr>
                        </table>
                    </div>
                    <br />
                    <div class="popup-divbottombtn">
                        <input type="button" id="btnCancel" class="mainbtn type1" style="width:95px; height:30px; font-size:12px" value="취소" onclick="fnCancel()"/>
                        <input type="button" id="btnRequest" class="mainbtn type1" style="width:95px; height:30px; font-size:12px" value="신청"/>
                        <%--<input id="btnCancel" type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="취소" onclick="fnCancel()"/>
                        <input id="btnRequest" type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="신청"/>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- DIV 팝업창 끝 --%>


    <script type="text/javascript">
        $(function () {

            $(".tabButton1").on("click", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("out.jpg", "over.jpg"));
                $("img", ".tabButton2").attr("src", $("img", ".tabButton2").attr("src").replace("on.jpg", "off.jpg"));
            });


            $(".tabButton2").on("click", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("off.jpg", "on.jpg"));
                $("img", ".tabButton1").attr("src", $("img", ".tabButton1").attr("src").replace("over.jpg", "out.jpg"));
            });
        });


        //$(function () {

        //    $("#btnTab-1").on("click", function () {
        //        $("img", this).attr("src", $("img", this).attr("src").replace("off.jpg", "on.jpg"));
        //        $("img", "#btnTab2").attr("src", $("img", "#btnTab2").attr("src").replace("on.jpg", "off.jpg"));
        //    });

        //    $("#btnTab-2").on("click", function () {
        //        $("img", this).attr("src", $("img", this).attr("src").replace("off.jpg", "on.jpg"));
        //        $("img", "#btnTab1").attr("src", $("img", "#btnTab1").attr("src").replace("on.jpg", "off.jpg"));
        //    });
        </script>

</asp:Content>


 