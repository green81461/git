<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Master/Default.master" CodeFile="SiteInfoGuide.aspx.cs" Inherits="Other_SiteInfoGuide" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	
	<style type="text/css">
		#guideIMG img{margin-bottom:10px;}
		#guideList{width:100%; height:200px; margin-top:20px; width:100%; padding:5px 0px; border:5px solid #a2a2a2; box-sizing:border-box; color:#454545; font-size:11pt; line-height:18pt; float:left; margin-bottom:30px; text-align:left}

		.anchor{display: block;  height: 0px;   visibility: hidden;}
		.list li{ width:240px; height:24px;background-color:#fff; margin-bottom:1px; padding-left:10px; border-bottom:1px dotted #a2a2a2;}
        .list a:hover li{ width:240px; height:24px;background-color:#ececec; margin-bottom:1px; font-weight:bold}
	</style>
	 <script type="text/javascript">
        $(document).ready(function () {
            $('a[href^="#"]').on('click', function (e) {
                e.preventDefault();

                var target = this.hash;
                var $target = $(target);
                

                $('html, body').stop().animate({
                    'scrollTop': $target.offset().top
                }, 1000, 'linear', function () {
                    window.location.hash = target;
                });
            });
        });
    </script>


    <div class="sub-contents-div">
        
        <%--<div class="div-main-tab">
                <ul>
                    <li>
                        <a href="SiteInfoGuide.aspx" class='tabOn' style="width:230px; height:35px; font-size:12px">사이트 이용가이드</a>
                      
                    </li>
                    <li>
                          <a href="PayInfoGuide.aspx" class='tabOff' style="width:230px; height:35px; font-size:12px">결제 가이드</a>
                    </li>
                </ul>
            </div>--%>
        <div class="div-main-tab" style="width: 100%; ">
            <ul>
                <li  class='tabOn' style="width: 185px;" onclick="location.href='SiteInfoGuide.aspx'">
                    <a href="SiteInfoGuide.aspx" >사이트 이용가이드</a>
                </li>
                <li  class='tabOff' style="width: 185px;" onclick="location.href='PayInfoGuide.aspx'">
                    <a href="PayInfoGuide.aspx" >결제 가이드</a>
                 </li>
            </ul>
        </div>
		
		<div class="sub-title-div">
	        <p class="p-title-mainsentence">
                       사이트이용가이드
                       <span class="span-title-subsentence">사이트 이용 방법을 확인 할 수 있습니다.</span>
            </p>
         </div>
		
		<div id="guideList">
			<div style="width:1070px; height:180px; margin:0 auto; margin-top:0px;">
                <span class="anchor" id="Span1"></span>
				<div >
					<p style="font-size:15pt; font-weight:bold; margin-left:30px; margin-top:10px;">바로가기 &nbsp;<span style="font-size:10pt;">클릭하시면 해당 메뉴로 이동합니다.</span></p>
					
					<div class="list" style=" float:left; margin-left:20px; margin-bottom:10px ">
						<a href="#guide2"><li>01. 우리안이란?</li></a>
						<a href="#guide3"><li>02. 목차</li></a>
						<a href="#guide4"><li>03. 화면구성</li></a>
						<a href="#guide6"><li>04. 회원가입</li></a>
						<a href="#guide7"><li>05. 로그인</li></a>
					</div>	
					<div class="list" style=" float:left; margin-left:20px; margin-bottom:10px ">
						
						<a href="#guide8"><li>06. 상품검색</li></a>
						<a href="#guide9"><li>07. 장바구니</li></a>
						<a href="#guide10"><li>08. 주문하기</li></a>
						<a href="#guide12"><li>09. 주문내역조회</li></a>
						<a href="#guide13"><li>10. 그룹웨어 : 구매요청</li></a>
					</div>
					<div class="list" style=" float:left; margin-left:20px; margin-bottom:10px ">
						
						<a href="#guide15"><li>11. 그룹웨어 : 구매승인</li></a>
						<a href="#guide16"><li>12. 그룹웨어 : 승인내역</li></a>
						<a href="#guide18"><li>13. 그룹웨어 : 결재상신</li></a>
						<a href="#guide20"><li>14. 그룹웨어 : 미결함</li></a>
						<a href="#guide21"><li>15. 그룹웨어 : 기결함</li></a>
					</div>
					<div class="list" style=" float:left; margin-left:20px; margin-bottom:10px ">	
						
						<a href="#guide23"><li>16. 관심상품</li></a>
						<a href="#guide24"><li>17. 간편주문</li></a>
						<li style="margin-top:45px; border:none">
						<asp:ImageButton ID="Guidebutton" runat="server" OnClick="Guidebutton_Click" ImageUrl="~/Images/SiteGuide/SiteGuide_down_btn.jpg" /></li>


					</div>

				</div>
			</div>
		</div>
		
		
		<div id="guideIMG" style="margin-top:20px;">
			<li >
				<img src="../images/Siteguide/Urian_GUIDE_1.jpg" >
			</li>
			<li>
				<span class="anchor" id="guide2"></span>
				<img src="../images/Siteguide/Urian_GUIDE_2.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide3"></span>
				<img src="../images/Siteguide/Urian_GUIDE_3.jpg" />
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide4"></span>
				<img src="../images/Siteguide/Urian_GUIDE_4.jpg" />
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide5"></span>
				<img src="../images/Siteguide/Urian_GUIDE_5.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide6"></span>
				<img src="../images/Siteguide/Urian_GUIDE_6.jpg" />
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide7"></span>
				<img src="../images/Siteguide/Urian_GUIDE_7.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide8"></span>
				<img src="../images/Siteguide/Urian_GUIDE_8.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide9"></span>
				<img src="../images/Siteguide/Urian_GUIDE_9.jpg" />
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide10"></span>
				<img src="../images/Siteguide/Urian_GUIDE_10.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide11"></span>
				<img src="../images/Siteguide/Urian_GUIDE_11.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide12"></span>
				<img src="../images/Siteguide/Urian_GUIDE_12.jpg" />
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide13"></span>
				<img src="../images/Siteguide/Urian_GUIDE_13.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide14"></span>
				<img src="../images/Siteguide/Urian_GUIDE_14.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide15"></span>
				<img src="../images/Siteguide/Urian_GUIDE_15.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide16"></span>
				<img src="../images/Siteguide/Urian_GUIDE_16.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide17"></span>
				<img src="../images/Siteguide/Urian_GUIDE_17.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide18"></span>
				<img src="../images/Siteguide/Urian_GUIDE_18.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide19"></span>
				<img src="../images/Siteguide/Urian_GUIDE_19.jpg""/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide20"></span>
				<img src="../images/Siteguide/Urian_GUIDE_20.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide21"></span>
				<img src="../images/Siteguide/Urian_GUIDE_21.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide22"></span>
				<img src="../images/Siteguide/Urian_GUIDE_22.jpg" />
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide23"></span>
				<img src="../images/Siteguide/Urian_GUIDE_23.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide24"></span>
				<img src="../images/Siteguide/Urian_GUIDE_24.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
			<li>
				<span class="anchor" id="guide25"></span>
				<img src="../images/Siteguide/Urian_GUIDE_25.jpg"/>
				<span style="float:right; display:block;  width:23px;  height:23px; font-weight:bold; font-size:10pt;  font-family:@돋움; line-height:20pt;"><a href="#Span1">top</a></span>
			</li>
		</div>
       



    
    </div>
</asp:Content>
