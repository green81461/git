<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" CodeFile="SiteInfoGuide.aspx.cs" Inherits="AdminSub_Other_SiteInfoGuide" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
        <style type="text/css">
		#guideIMG img{margin-bottom:10px;}
		#guideList{width:1214px; height:200px; margin-top:20px; padding:5px 0px; border:5px solid #a2a2a2; box-sizing:border-box; color:#454545; font-size:11pt; line-height:18pt; float:left; margin-bottom:30px; text-align:left}

		.anchor{display: block; visibility: hidden;}
		.list li{ width:240px; height:24px;background-color:#fff; margin-bottom:1px; padding-left:10px; border-bottom:1px dotted #a2a2a2;list-style: none;}
        .list a:hover li{ width:240px; height:24px;background-color:#ececec; margin-bottom:1px; font-weight:bold}
	</style>
	 <script type="text/javascript">
          var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
        $(document).ready(function () {
            $('a[href^="#"]').on('click', function (e) {
                e.preventDefault();

                var target = this.hash;
                var $target = $(target);

                $('html, body').stop().animate({
                    'scrollTop': $target.offset().top
                }, 1000, 'linear', function () {
                    //window.location.hash = target;
                });
            });

             

            $('.topbtn').click(function () {
                $('html, body').animate({ scrollTop: 0 }, 400);
                return false;
            });

            $('.div-main-tab > ul > li').click(function () {
                if ($(this).attr('id') == 'lisi') {
                    $(this).attr('onClick', "location.href='SiteInfoGuide.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'SiteInfoGuide.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lipi') {
                    $(this).attr('onClick', "location.href='PayInfoGuide.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'PayInfoGuide.aspx?ucode='+ucode+'');
                }
            })
        });
    </script>


    <div class="sub-contents-div">
        
		
		
		
		
		
		 <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    사이트 이용가이드
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
        <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li id="lisi"  class='tabOn' style="width: 185px;">
                        <a>사이트이용가이드</a>
                    </li>
                    <li id="lipi" class='tabOff' style="width: 185px;">
                        <a>결제가이드</a>
                     </li>
                </ul>
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
						<li style="border:none">
						<asp:ImageButton ID="Guidebutton" runat="server" OnClick="Guidebutton_Click" ImageUrl="~/Images/SiteGuide/SiteGuide_down_btn.jpg" /></li>


					</div>

				</div>
			</div>
		</div>
		
		
		<div id="guideIMG" style="margin-top:20px;">
			<li >
				<img src="/images/Siteguide/Urian_GUIDE_1.jpg" >
			</li>
			<li>
				<span class="anchor" id="guide2"></span>
				<img src="/images/Siteguide/Urian_GUIDE_2.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide3"></span>
				<img src="/images/Siteguide/Urian_GUIDE_3.jpg" />
				
			</li>
			<li>
				<span class="anchor" id="guide4"></span>
				<img src="/images/Siteguide/Urian_GUIDE_4.jpg" />
				
			</li>
			<li>
				<span class="anchor" id="guide5"></span>
				<img src="/images/Siteguide/Urian_GUIDE_5.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide6"></span>
				<img src="/images/Siteguide/Urian_GUIDE_6.jpg" />
				
			</li>
			<li>
				<span class="anchor" id="guide7"></span>
				<img src="/images/Siteguide/Urian_GUIDE_7.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide8"></span>
				<img src="/images/Siteguide/Urian_GUIDE_8.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide9"></span>
				<img src="/images/Siteguide/Urian_GUIDE_9.jpg" />
				
			</li>
			<li>
				<span class="anchor" id="guide10"></span>
				<img src="/images/Siteguide/Urian_GUIDE_10.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide11"></span>
				<img src="/images/Siteguide/Urian_GUIDE_11.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide12"></span>
				<img src="/images/Siteguide/Urian_GUIDE_12.jpg" />
				
			</li>
			<li>
				<span class="anchor" id="guide13"></span>
				<img src="/images/Siteguide/Urian_GUIDE_13.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide14"></span>
				<img src="/images/Siteguide/Urian_GUIDE_14.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide15"></span>
				<img src="/images/Siteguide/Urian_GUIDE_15.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide16"></span>
				<img src="/images/Siteguide/Urian_GUIDE_16.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide17"></span>
				<img src="/images/Siteguide/Urian_GUIDE_17.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide18"></span>
				<img src="/images/Siteguide/Urian_GUIDE_18.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide19"></span>
				<img src="/images/Siteguide/Urian_GUIDE_19.jpg""/>
				
			</li>
			<li>
				<span class="anchor" id="guide20"></span>
				<img src="/images/Siteguide/Urian_GUIDE_20.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide21"></span>
				<img src="/images/Siteguide/Urian_GUIDE_21.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide22"></span>
				<img src="/images/Siteguide/Urian_GUIDE_22.jpg" />
				
			</li>
			<li>
				<span class="anchor" id="guide23"></span>
				<img src="/images/Siteguide/Urian_GUIDE_23.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide24"></span>
				<img src="/images/Siteguide/Urian_GUIDE_24.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide25"></span>
				<img src="/images/Siteguide/Urian_GUIDE_25.jpg"/>
				
			</li>
		</div>
       



    
    </div>
    <div style="position: fixed;     left: 88%; top:90%; cursor:pointer">
         <p class="topbtn"><a><span> <img style="" src="/AdminSub/Images/topimg.png" /></span></a></p>
    </div>
    
</asp:Content>
