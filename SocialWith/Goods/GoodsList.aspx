<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="GoodsList.aspx.cs" Inherits="Goods_GoodsList" %>

<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
    <asp:Literal runat="server" ID="goodsCss" EnableViewState="false"></asp:Literal>
    <script type="text/javascript">
        var qsFinalCategoryCode;
        var qsBrandCode;
        var qsBrandName;
        var qsGoodsName;
        var qsReGoodsName;
        var qsGoodsModel;
        var qsGoodsCode;
        var qsType;
        var qsListType;
        var qsPageNo;
        var qsOrderType;
        var qsSearchFlag
        var totalCount;
        var listType = 'a';
        var bCodes;
       
        
    </script>
    <asp:Literal runat="server" ID="goodsListjs" EnableViewState="false"></asp:Literal>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
            <div class="ctgrselector-wrap">
                <div class="ctgrselector" id="ctgrMenuDiv">
                            <img src="/Images/home-icon.png"  class="home-icon" onclick="location.href='/Default.aspx'"/>&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow"/>&nbsp;&nbsp;
                            <select class="category_select" id="ddlCategory01" onchange="fnCategoryChanged(this,1);">
                                <option value="All">---전체---</option>
                            </select>&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow"/>&nbsp;&nbsp;
                            <select class="category_select" id="ddlCategory02" onchange="fnCategoryChanged(this,2);" >
                                <option value="All">---전체---</option>
                            </select>&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow"/>&nbsp;&nbsp;
                            <select class="category_select" id="ddlCategory03" onchange="fnCategoryChanged(this,3);" >
                                <option value="All">---전체---</option>
                            </select>&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow"/>&nbsp;&nbsp;
                            <select class="category_select" id="ddlCategory04" onchange="fnCategoryChanged(this,4);" >
                                <option value="All">---전체---</option>
                           </select>&nbsp;&nbsp;&nbsp;<img src="/Images/icon-category-right.png" class="rightarrow"/>&nbsp;&nbsp;
                           <select class="category_select" id="ddlCategory05" onchange="fnCategoryChanged(this,5);" >
                                <option value="All">---전체---</option>
                           </select>
                </div>
                &nbsp;&nbsp;
            
            </div>

            <br />
            <div class="goodslist-researchwrap"  >
                <div class="goodslist-research-certify">
                    <span class="title">인증상품</span>

                    <input id="certify1" class="css-certify-input" type="checkbox"  onclick="fnCertifyCheck();" />
                    <label for="certify1" class="css-certify-lb" ><span></span><img src="../UploadFile/CertificationImage/01.jpg" /></label> 

                    <input id="certify2"  class="css-certify-input" type="checkbox"  onclick="fnCertifyCheck();"/>
                    <label for="certify2" class="css-certify-lb"><span></span><img src="../UploadFile/CertificationImage/02.jpg" /></label> 

                    <input id="certify3"  class="css-certify-input" type="checkbox"  onclick="fnCertifyCheck();"/>
                    <label for="certify3" class="css-certify-lb"><span></span><img src="../UploadFile/CertificationImage/03.jpg" /></label> 

                    <input id="certify4"  class="css-certify-input" type="checkbox"  onclick="fnCertifyCheck();"/>
                    <label for="certify4" class="css-certify-lb" ><span></span><img src="../UploadFile/CertificationImage/04.jpg" /></label> 

                    <input id="certify5" class="css-certify-input"  type="checkbox"  onclick="fnCertifyCheck();"/>
                    <label for="certify5" class="css-certify-lb" ><span></span><img src="../UploadFile/CertificationImage/05.jpg" /></label> 
                    <input type="hidden" id="hdCertifyCode" value="00000000"/>
                    
                  
                </div>
                <div class="goodslist-research-etc" style="">
                    <span class="title">상품명</span>
                    <input type="text" id="txtResGoodsName" onkeypress="return fnGoodsReSearchEnter();" >
                    <span class="title">상품코드</span>
                    <input type="text" id="txtResGoodsCode" onkeypress="return fnGoodsReSearchEnter();" >
                    <span class="title">모델명</span>
                    <input type="text" id="txtResGoodsModel" onkeypress="return fnGoodsReSearchEnter();" >


                     <input type="button" title="검색" value="검색" class="mainbtn type1" style="margin-right:1px; border-radius:0; margin-left: 55px; background-image:url(/./images/serch_ca_ri.png); background-repeat:no-repeat; width: 70px; background-position:2px 3px; height: 30px;padding-left:25px; font-size: 12px; line-height:32px" onclick="fnSearchGoodsList(); return false;"/>
                    <input type="button" title="초기화" value="초기화" class="mainbtn type1" style="background-image:url(/./images/reaset_ca_ri.png); border-radius:0; background-repeat:no-repeat; margin-right:20px; width:70px; margin-left: 10px; padding-left:27px; background-position:-3px 2px;  height: 30px; font-size: 12px; line-height:32px" id="btnReset" />
                </div>
                <div class="goodslist-research-brand" style="display:none" >
                    <span class="title">브랜드</span>
                    <ul id="ulBrandList"></ul>
                    <input type="button" class="mainbtn type2" id="btnMoreBrand" value="+ 더보기"  style="width: 70px; height: 30px; border-radius:0; font-size: 12px; position: absolute; top: 45px; left: 50%; margin-left:520px; line-height:27px"/>
                </div>
                
        <div class="goodslist-brand-check-view" style="display:none">
            <span class="title">선택조건</span>
            <ul class="goodslist-brand-check-ul">
       
            </ul>
            </div>
        </div>
        <div id="divBrandArea" class="goodslist-brand-buttonwrap txt-center"  style="display: none;">
                   
            <button id="btnBrandWrap" type="button" onclick="fnToggle(); return false;">브랜드상세 <i class="fas fa-angle-down"></i></button>

        </div>
           <div id="divGoodsCount"></div>
            <div id="menu" class="goodslist-topbar">
               
                <div id="divOrder" class="goodslist-topbar-order">
                     
                    <input type="hidden" id="hdOrderValue" value="1" />
                    <ul>
                        <li>
                            <a onclick="fnOrderListBind(this,'2')">낮은가격순</a> 
                        </li>
                        <li>
                            <a onclick="fnOrderListBind(this,'3')">높은가격순</a>
                        </li>
                        <li>
                            <a onclick="fnOrderListBind(this,'4')">상품명순</a>
                        </li>
                        <li>
                            <a onclick="fnOrderListBind(this,'5')">브랜드순</a>
                        </li>
                    </ul>
                </div>
                <div class="goodslist-topbar-listtype">
                    <a class="gridlink" onclick="fnLinkType('grid'); return false;" id="link_grid" >
                        <img class="gridicon" title="썸네일형 보기" alt="그리드" id="img_Grid" src="../Images/Goods/gridview-on.png" style="display: none" /></a>
                    <a class="listlink" onclick="fnLinkType('list'); return false;" id="link_list" >
                        <img class="listcon" title="리스트형 보기" alt="리스트" id="img_List" src="../Images/Goods/listview-off.png" style="display: none" /></a>
                </div>
                <%--<div class="goodslist-favorites" id="Favorites"><a id="spanFavorites" onclick="addBookmark()" style="cursor: pointer; display: none"></a></div>--%>
            </div>
           
            <div id="pagination" class="page_curl" style="padding-bottom:7px"></div>
            
            <div class="goodslist-wrap">
                <div class="grid-parent-frame" id="divGrid" style="display: none;"></div>
                <div class="list-parent-frame" id="divList" style="display: none;"></div>
                
            </div>
         
            <input type="hidden" id="hdTotalCount" />
            <input type="hidden" id="hdLinkType" />
            <input type="hidden" id="hdpageNum" />
            <input type="hidden" id="hdListType" />
            <div style="clear: both;">
                <div id="paginationBottom" class="page_curl"></div>
            </div>
           

            <%--상세검색 검색결과가 없을때 보여주는 메세지 시작--%>
            <div class="search-emptywrap" style="display: none;">

                <table>
                    <tr>
                        <td rowspan="5" class="search-empty-cautionicon" >
                            <img src="../images/Goods/caution_icon.jpg" />
                        </td>
                        <td class="title">상품코드 : <span id="spanGoodsCodekeyword" class="keyword"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">상품명 : <span id="spanGoodsNamekeyword" class="keyword"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">모델명 : <span id="spanGoodsModelkeyword" class="keyword"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="title">브랜드명 :<span id="spanGoodsBrandkeyword" class="keyword"></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="result">에 대한 검색 결과가 없습니다.<br />
                            <span>검색어의 입력이 정확히 되었는지 다시 한번 확인해주세요.</span>
                        </td>
                    </tr>
                </table>
            </div>
            <%--상세검색 검색결과가 없을때 보여주는 메세지 끝--%>

            <%--파워서치 검색결과가 없을때 보여주는 메세지 시작--%>
            <div class="powersearch-emptywrap" id='divEmptyMsg'>
                <div class="powersearch-empty-result">
                    
                    <span id="noResultMsg" ></span>&nbsp;<span class="resulttext" >에 대한 검색 결과가 없습니다.</span>
                </div>

                <div class="imgetextnam">
                    <div class="imgetexttop">
                        <div class="leftimgetext">
                            <p class="leftimgetext_seach"><img src="../images/Goods/tip.jpg" /> </p>
                        </div>
                        <div class="rightimgetext">
                            <p><span class="jumnam">*</span><span> 검색어에</span> <span class="red">오타자를</span><span> 확인해보세요.</span></p>
                            <p><span class="jumnam">*</span><span> 보다</span> <span class="red">일반적인 단어</span><span>로 검색해보세요.</span></p>
                            <p><span class="jumnam">*</span><span></span> <span class="red">정확하지않은 단어</span><span>는 빼거나 붙여서 검색해보세요.</span></p>
                            <p><span class="jumnamex">예)</span></p><p><span>스테플러 33C (X)</span><span><img src="../images/Goods/rightnam.png"></span> <span class="red">스테플러33C (O) ,&nbsp;&nbsp; 스테플러 (O)</span></p>
                            <p><span> 황동 볼밸브 (X)</span><span><img src="../images/Goods/rightnam.png"></span> <span class="red">밸브 (O)</span></p>
                        </div>
                    </div>
                </div>


                <div class="bottomimgetext">
                    <p><span class="red">"카테고리명, 브랜드명"</span><span>으로 검색하시면 정확한 검색이 가능합니다.</span></p>
                    <p><span>더 궁금하신 사항은 </span><span class="red">고객센터</span><span>로 문의 주시기 바랍니다.</span> <span>감사합니다.</span></p>
                    <p><span></span><span class="red">고객센터 </span><span>(1811-7820)</span><span> </span></p>
                </div>
                <div class="sangimgnam">
                    <a href="/Board/BoardInsertByMember.aspx">상품문의 하기</a>
                </div>
            </div>

            <%--파워서치 검색결과가 없을때 보여주는 메세지 끝--%>

            <%--링크검색시 검색결과가 없을때 보여주는 메세지 시작--%>
            <div id='divDiscontinueMsg' style="display: none; width: 100%; height: 160px; text-align: center">
                <img src="../images/Goods/caution_icon.jpg"><span style="font-weight: bold; font-size: medium">해당 상품이 단종되었습니다.</span>
            </div>

            <%--링크검색시 검색결과가 없을때 보여주는 메세지 끝--%>

            <%--카테고리 클릭시 보여주는 메세지 시작--%>
            <div id='divGoodsReadyMsg' style="display: none; width: 100%; height: 160px; text-align: center">
                <img src="../images/Goods/caution_icon.jpg"><span style="font-weight: bold; font-size: medium">상품 준비중 입니다.</span>
            </div>

            <%--카테고리 검색결과가 없을때 보여주는 메세지 끝--%>

    </div>
    <%--로딩패널 시작--%>
                <div class="wrap-loading-wrap" style="display: none;" id="divLoading">
                    <div class="wrap-loading">
                        <img src="../Images/loading.gif" />
                    </div>
                </div>
                <%--로딩패널 끝--%>
    <div id="moreBranddiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 600px;">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('moreBranddiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <h3>브랜드 더보기</h3>
                <div class="divpopup-layer-conts" style="height: 500px; overflow-y:scroll; overflow-x:hidden; border:1px solid darkgrey">
                    <ul id="ulMoreBrandList" style="margin:0 auto; width:630px; float: left; padding:5px"></ul>
                </div>

                <div style="text-align: right; margin-top: 10px;">
                    <input type="button" class="mainbtn type1" style="background-image:url(/./images/serch_ca_ri.png); background-repeat:no-repeat;width: 74px; height: 25px;padding-left:28px; font-size: 12px; line-height:27px" value="검색" id="btnMoreBrandSearch" />
                </div>

            </div>
        </div>
    </div>
</asp:Content>

