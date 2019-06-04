<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="GoodsDetail.aspx.cs" Inherits="Goods_GoodsDetail" %>

<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" src="tableHeadFixer.js"></script>
    <asp:Literal runat="server" ID="goodsCss" EnableViewState="false"></asp:Literal>
    <script type="text/javascript">

        var qs = fnGetQueryStrings();
        var qsGroupCode;
        var qsGoodsCode;
        var qsBrandCode;
        var qsFinalCategoryCode;


        var qsType;
        var is_sending = false;


    </script>
    <asp:Literal runat="server" ID="goodsDetailjs" EnableViewState="false"></asp:Literal>
    <%--확대보기 스크립트 시작--%>
    <%--<script type="text/javascript" src="jquery-1.4.4.min.js"></script>--%>
    <script type="text/javascript" src="slick.js"></script>
    <script type="text/javascript" src="../Scripts/jquery.elevatezoom.js"></script>



    <%--확대보기 스크립트 끝--%>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        <div class="ctgrselector-wrap">
            <div class="ctgrselector" id="ctgrMenuDiv">
                <img src="/Images/home-icon.png" class="home-icon" onclick="location.href='/Default.aspx'" />&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow" />&nbsp;&nbsp;
                            <select class="category_select" id="ddlCategory01" onchange="fnCategoryChanged(this,1);">
                                <option value="All">---전체---</option>
                            </select>&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow" />&nbsp;&nbsp;
                            <select class="category_select" id="ddlCategory02" onchange="fnCategoryChanged(this,2);">
                                <option value="All">---전체---</option>
                            </select>&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow" />&nbsp;&nbsp;
                            <select class="category_select" id="ddlCategory03" onchange="fnCategoryChanged(this,3);">
                                <option value="All">---전체---</option>
                            </select>&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow" />&nbsp;&nbsp;
                            <select class="category_select" id="ddlCategory04" onchange="fnCategoryChanged(this,4);">
                                <option value="All">---전체---</option>
                            </select>&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow" />&nbsp;&nbsp;
                           <select class="category_select" id="ddlCategory05" onchange="fnCategoryChanged(this,5);">
                               <option value="All">---전체---</option>
                           </select>
            </div>
            <input type="hidden" id="hdGoodName" />
        </div>

        <div class="goodsdetail-info-wrap">
            <div class="goodsdetail-info">
                <img id="zoom_01" class="mainimg" onerror="this.src='/Images/noImage.jpg'" />
                <div class="zoomimg" id="demo-container"></div>

                <div class="goodsdetail-zoomtextwrap">
                    <span>
                        <img src="../images/Goods/sub_expand_icon.png">
                        &nbsp;마우스를 올려보세요<br />
                    </span>
                </div>

            </div>

            <table class="goods_detail_maintable">
                <tr class="brandinfo" id="lblTitleBrand" style="display: none;">
                    <td class="info">
                        <b id="lblBrand"></b>
                    </td>
                </tr>
                <tr class="cert" id="trCert" style="display: none; border-bottom: 1px solid #eaeaea;">
                    <td colspan="2">
                        <div class="imagewrap" id="divCertImage">
                        </div>
                        <div class="textwrap">
                            <span>*본 제품은 인증상품입니다.</span>
                        </div>
                    </td>

                </tr>
                <tr style="border-bottom: 1px solid #eaeaea;">
                    <td class="titlename" colspan="2">
                        <label id="lblGoodsName" class="goodsinfo"></label>
                    </td>
                </tr>
                <%--<tr id="lblTitleModel" style="display: none">
                        <td>
                            <span>모델명</span>
                        </td>
                        <td>
                            <b id="lblModel" class="modelname"></b>
                        </td>
                    </tr>--%>
            </table>

            <table class="goods_detail_table">


                <tr id="lblTitleDeliveryOrder" style="display: none; border-bottom: 1px solid #eaeaea;">
                    <td class="title">
                        <span>발송일</span>
                    </td>
                    <td class="info" id="tdDeliveryOrder">
                </tr>







                <tr id="lblTitleOrigin" style="display: none; border-bottom: 1px solid #eaeaea;">
                    <td class="title">
                        <span>원산지</span>
                    </td>
                    <td class="info">
                        <%--<img id="ImgOrigin" style="border: 1px solid #a2a2a2; margin: 0 auto" onerror="this.src='http://www.socialwith.co.kr/Images/X.jpg'" />--%>
                        <b id="lblOrigin"></b>

                    </td>
                </tr>



                <tr id="lblTitleSpecial" style="display: none; border-bottom: 1px solid #eaeaea;">
                    <td class="title">
                        <span>특징</span>
                    </td>
                    <td class="info">
                        <b id="lblSpecial"></b>
                    </td>
                </tr>

                <tr id="lblTitleFormat" style="display: none; border-bottom: 1px solid #eaeaea;">
                    <td class="title">
                        <span>형식</span>
                    </td>
                    <td class="info">
                        <b id="lblFormat"></b>
                    </td>
                </tr>

                <tr id="lblTitleCause" style="display: none; border-bottom: 1px solid #eaeaea;">
                    <td class="title">
                        <span>주의사항</span>
                    </td>
                    <td class="info">
                        <b id="lblCause"></b>
                    </td>
                </tr>
                <tr id="lblTitleSupplies" style="display: none; border-bottom: 1px solid #eaeaea;">
                    <td class="title">
                        <span>용도</span>
                    </td>
                    <td class="info">
                        <b id="lblSupplies"></b>
                    </td>
                </tr>
            </table>
            <div class="goods_standardinfo">
                <span class="info1">*&nbsp;월요일~금요일 PM 04:00까지 주문완료건 재고 있는 상품에 한하여 당일발송&nbsp;
                                        <br />
                    * 상품의 재고상황에 따라 발송이 지연되거나, 구매가 불가능해지는 경우 당사에서 고객님께 연락을 드립니다.
                        <br />
                    * 당사는 당일 출하상품을 지속적으로 확대하여 빠른배송을 위해 최선을 다하고있습니다.
                </span>
                <br />
                <span class="info2" style="display: none" id="spanGoodsInfoMsg">* 부서별 주문최저금액 상온식품 12만원(VAT포함), 저온식품  5만원(VAT포함) 이상 주문시 배송 가능합니다.</span>
            </div>
            <div class="mainbtn-area">
                <input type="button" class="mainbtn bookmark pad_right" value="즐겨찾기" onclick="addBookmark();" />
                <input type="button" class="mainbtn funmark" value="찜하기" onclick="fnAddWish();" />
                <input type="button" id="btnOptioinSummary"  class="mainbtn option pad_left" value="옵션전체보기" onclick="fnShowAllSummary();" />
            </div>
        </div>
        
        <div class="goodsdetail-optionselector-wrap" style="">
            <div class="goodsdetail-optionselector-title" style="position: relative">
                <h4>빠른 옵션 선택
                        
                </h4>
                <input type="button" id="btnOptionSelect" value="초기화" class="mainbtn stat type1" />
            </div>
            <div class="goodsdetail-optionselector" id="divOptionSelector"></div>
        </div>

        <div style="width: 100%; padding-top: 15px; float: left;">
            <div style="display: inline-block; float: left">
                <h4 style="font-weight: bold">상품 옵션</h4>
            </div>
            <div style="float: right; display: inline-block" id="Div1" runat="server">
                <input type="button" class="mainbtn type1" style="width: 117px; height: 30px; margin-right: 3px; font-size: 12px" value="장바구니 담기" onclick="fnAddCart();" />
                <input type="button" class="mainbtn type2" style="width: 117px; height: 30px; font-size: 12px" value="주문하기" onclick="fnOrder();" />


            </div>
        </div>
        <br />
        <div style="width: 100%; overflow-x: auto">
            <input type="hidden" id="hdGroupCode" />
            <input type="hidden" id="hdFirstGoodsCode" />
            <input type="hidden" id="hdFirstGroupCode" />
            <table id="summaryList" class="tbl_main">
                <thead>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
        <br />

        <br />
        <div id="DivCount" class="totalCost-div" style="float: right">
            총 선택 상품개수 :   
                <label id="lblCheckCnt" style="font-size: 16px;">0  </label>
            개 / 총 주문 금액 (VAT포함) : 
                <label id="lbTotalCheckPrice" style="font-size: 16px;">0</label>
            원
 
              


        </div>
        <br />
        <br />
        <br />

        <div class="goodsdetail-btnarea" id="bottomButtonDiv" runat="server">
            <input type="button" class="mainbtn type1" style="width: 117px; height: 30px; margin-right: 3px; font-size: 12px" value="장바구니 담기" onclick="fnAddCart();" />
            <input type="button" class="mainbtn type2" style="width: 117px; height: 30px; font-size: 12px" value="주문하기" onclick="fnOrder();" />
        </div>

        <div class="goodsdetail-detailimgarea ">
            <div id="divDetailImage1"></div>
            <div id="divDetailImage2"></div>
            <div id="divDetailImage3"></div>
            <div id="divDetailImage4"></div>
        </div>

        <div class="emptyDiv-m"></div>
        <%-- <div class="div-main-tab" style="width: 100%;">
                <ul id="hint_tab">

                    <li class="tabOn" id="litab1" style="width: 156px"><a>카테고리 인기상품</a></li>
                    <li class="tabOff" id="litab2" style="width: 156px"><a>브랜드 인기상품</a></li>

                </ul>
            </div>--%>




        <p class="goodsdetail_hint_title"><span style="margin-right:5px;vertical-align:middle;"><img src="/images/text_star_balck.png" /></span><span style="vertical-align:middle; font-size:20px;color:black;">카테고리 인기상품</span></p>
        <!-- 카테고리 인기상품 시작-->
        <div class="category-hint" style="width: 100%;">
            <section class="category-hint-image slider">
            </section>
        </div>
        <!-- 카테고리 인기상품끝-->

        <div class="emptyDiv-m"></div>
        <p class="goodsdetail_hint_title"><span style="margin-right:5px;vertical-align:middle;"><img src="/images/text_star_balck.png" /></span><span style="vertical-align:middle; font-size:20px;color:black;">브랜드 인기상품</span></p>
        <!-- 브랜드 내 인기상품 시작-->

        <div class="brand-hint" style="width: 100%;">
            <section class="brand-hint-image slider">
            </section>
        </div>

        <!-- 브랜드 내 인기상품 끝-->

        <%--검색결과가 없을때 보여주는 메세지 시작--%>
        <div class="sub-contents-empty-div" style="display: none; width: 100%; height: 160px; float: left">
            <div style="margin: 45px auto; width: 600px;">
                <div style="float: left">
                    <img src="../images/Goods/caution_icon.jpg">
                </div>
                <div style="text-align: center; vertical-align: middle; color: #69696c; width: 600px; height: 60px; font-size: 18px; line-height: 25px;">

                    <span id="spansearchkeyword" style="font-size: 18px; color: #ec2028; font-weight: bold"></span>에 대한 검색 결과가 없습니다.<br />
                    <span style="font-size: 18px; font-family: Dotum; font-weight: bold; color: #69696c;">검색어의 입력이 정확히 되었는지 다시 한번 확인해주세요.</span>
                </div>
            </div>
        </div>
        <%--검색결과가 없을때 보여주는 메세지 끝--%>
    </div>

    <!--  상품디테일뷰-->
    <div id="popupDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 1000px; ">
            <div class="popupdivContents" style="">
                    <div style="width: 14px; height: 14px; float: right; margin-top: -10px;">
                        <button type="button" onclick="fnClosePopup(); return false;" class="close-bt">
                            <img src="../Images/Wish/icon-delete.jpg" /></button>
                    </div>

                    <div class="divpopup-layer-conts5">
                        <table style="width: 100%;">
                            <tr>
                                <td style="text-align: left; width: 300px; margin-top: 10px;" rowspan="5">
                                    <img id="imgGoodsDetail" width="300" height="300" onerror="this.src='/Images/noImage.jpg'" style="border: 1px solid #a2a2a2" />
                                    <div style="margin-top: 7px;">
                                        <span style="font-size: 12px; padding-left: 10px;">출하예정일 : </span>
                                        <label id="p_GoodsDueName" style="width: 60px; height: 20px; color: #ec2029"></label>
                                    </div>
                                    <div>
                                        <span id="spPopGdsSale" style="font-size: 12px; padding-left: 10px;">판매가(VAT포함) : </span>
                                        <label id="p_GoodsPriceVat" style="width: 170px; height: 20px; color: #ec2029"></label>
                                        <br />
                                        <span id="spPopTotalGdsSale" style="font-size: 12px; padding-left: 10px;">총 상품 금액(VAT포함) : </span>
                                        <label id="p_GoodsTotalPriceVat" style="width: 130px; height: 20px; color: #ec2029"></label>
                                    </div>
                                </td>
                                <td>
                                    <table style="width: 90%; height: 300px; margin-top: -60px; margin-left: 20px;">

                                        <tr>
                                            <td colspan="2" style="margin-top: -30px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsName" style="font-size: 18px; font-weight: bold; height: 35px; margin-top: 5px;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 80px; height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">상품코드</p>
                                            </td>
                                            <td style="width: 210px; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsCode" style="height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="height: 20px; font-weight: bold; text-align: center; margin: auto 0;">상품정보</p>
                                            </td>
                                            <td style="height: auto; border-bottom: 1px solid #a2a2a2;">
                                                <div style="overflow-y: auto; overflow-x: hidden; max-height: 82px;">
                                                    <p id="p_GoodsInfo" style="width: 100%; height: auto; padding-left: 5px; margin: auto 0;"></p>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">모델명</p>
                                            </td>
                                            <td style="height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsModel" style="width: 100%; height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">원산지</p>
                                            </td>
                                            <td style="width: 520px; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsOrigin" style="width: 100%; height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">최소수량</p>
                                            </td>
                                            <td style="width: 520px; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_moq" style="width: 100%; height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">내용량</p>
                                            </td>
                                            <td style="width: 520px; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsUnit" style="width: 100%; height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr id="trPopupCart" style="display: none">
                                            <td style="width: 100px; height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">수량</p>
                                            </td>
                                            <td style="height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <span class='input-qty'>
                                                    <input type='number' id='txtPopupQty' onblur="fnPopupTextboxBlur(this)" oninput='return maxLengthCheck(this)' onkeypress='return onlyNumbers(event);' onchange="fnPriceSet(this)" maxlength='4' />
                                                    <a class='input-arrow-up' id="popupArrowUp" onclick="fnPopupArrowClick('Up'); return false;">
                                                        <img src='../Images/inputarrow_up.png' width='9' height='9' class='imgarrowup' /></a>
                                                    <a class='input-arrow-down' id="popupArrowDown" onclick="fnPopupArrowClick('Down'); return false;">
                                                        <img src='../Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown' /></a>
                                                </span>&nbsp;&nbsp;
                                                <input type="button" class="mainbtn type2" value="장바구니 담기" onclick="fnPopupCartAdd();"/>

                                                <%--<a onclick="fnPopupCartAdd();" style="padding-left: 11px;">
                                                    <img src="../images/Goods/basket_in_btn1.jpg" alt="장바구니 담기" style="margin: 0 auto; padding-top: 4px" /></a>--%>
                                                <input type="hidden" id="hdPopupCategoryCode" />
                                                <input type="hidden" id="hdPopupGoodsGroupCode" />
                                                <input type="hidden" id="hdPopupGoodsCode" />
                                                <input type="hidden" id="hdGoodUnitMoq" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>

                        </table>
                    </div>
            </div>
        </div>
    </div>


    <!--  장바구니담기 모달-->

    <div id="cartDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 500px; ">
                <div class="divpopup-layer-conts">
                    <table style="text-align: center; margin: auto; text-align: left">
                        <tr>
                            <td style="text-align: left; width: 200px" colspan="2">
                                <h3>success</h3>
                            </td>
                        </tr>

                        <tr>
                            <td rowspan="2" style="padding-top: 20px; padding-right: 20px;">선택하신 상품이 
                                    <br />
                                <span style="color: red; font-weight: bold">장바구니</span>에 담겼습니다.
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <ul style="list-style: none;">
                                    <li style="padding-bottom: 10px;">
                                        <a onclick="fnGoCart(); return false;" style="padding-bottom: 20px;">
                                            <img src="../Images/Goods/cartList.jpg" alt="장바구니보기" /></a>
                                    </li>
                                    <li><a onclick="fnCartPopupClose(); return false;">
                                        <img src="../Images/Goods/keepShopping.jpg" alt=" 쇼핑계속하기" /></a>
                                    </li>
                                </ul>
                            </td>

                        </tr>
                    </table>
            </div>
        </div>
    </div>



    <!--관심상품 담기-->

    <div id="wishListDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 500px; ">
            <div class="popupdivContents" style="border: none;">
                    <div class="divpopup-layer-conts">
                        <table style="text-align: center; margin: auto; text-align: left">
                            <tr>
                                <td style="text-align: left; width: 200px" colspan="2">
                                    <h3>success</h3>
                                </td>
                            </tr>
                            <tr>
                                <td rowspan="2" style="padding-top: 20px; padding-right: 20px;">*선택하신 상품이 
                                    <br />
                                    <span style="color: red; font-weight: bold">관심상품 보관함에</span>에 담겼습니다.
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <ul style="list-style: none;">
                                        <li style="padding-bottom: 10px;">
                                            <a onclick="fnGoWish(); return false;" style="padding-bottom: 20px;">
                                                <img src="../Images/Goods/putCart-btn.jpg" alt="장바구니보기" /></a>
                                        </li>
                                        <li><a onclick="fnWishPopupClose(); return false;">
                                            <img src="../Images/Goods/keepShopping.jpg" alt=" 쇼핑계속하기" /></a>
                                        </li>
                                    </ul>
                                </td>


                            </tr>
                        </table>
                    </div>
            </div>
        </div>
    </div>


</asp:Content>

