<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" CodeFile="PayInfoGuide.aspx.cs" Inherits="AdminSub_Other_PayInfoGuide" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

	<style type="text/css">
		#guideIMG img{margin-bottom:10px;}
		#guideList{width:1214px; height:130px; margin-top:20px; padding:5px 0px; border:5px solid #a2a2a2; box-sizing:border-box; color:#454545; font-size:11pt; line-height:18pt; float:left; margin-bottom:30px; text-align:left}

		.anchor{display: block; visibility: hidden;}
		.list li{ width:240px; height:24px;background-color:#fff; margin-bottom:1px; padding-left:10px; border-bottom:1px dotted #a2a2a2;}
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
                   // window.location.hash = target;
                });
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

             $('.topbtn').click(function () {
                $('html, body').animate({ scrollTop: 0 }, 400);
                return false;
            });
        });
    </script>


    <div class="sub-contents-div">
        

		
		
		
		<!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    결제 가이드
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
        <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li id="lisi"  class='tabOff' style="width: 185px;">
                        <a>사이트이용가이드</a>
                    </li>
                    <li id="lipi" class='tabOn' style="width: 185px;">
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
						
					</div>	
					<div class="list" style=" float:left; margin-left:20px; margin-bottom:10px ">
						<a href="#guide4"><li>03. 선불결제(신용카드 외)</li></a>
						<a href="#guide5"><li>06. ARS(신용카드결제)방법</li></a>
					</div>
					<div class="list" style=" float:left; margin-left:20px; margin-bottom:10px ">
						<a href="#guide6"><li>07. 후불결제</li></a>
					</div>
					<div class="list" style=" float:left; margin-left:20px; margin-bottom:10px ">
						<li style="margin-top:0px; border:none">
							<asp:ImageButton ID="Guidebutton" runat="server" OnClick="Guidebutton_Click" ImageUrl="~/Images/PayGuide/PayGuide_down_btn.jpg" />
						</li>
					</div>

				</div>
			</div>
		</div>


		<div id="guideIMG" style="margin-top:20px;">
			<li >
				<img src="/images/Payguide/PayGuide-1.jpg" >
			</li>
			<li>
				<span class="anchor" id="guide2"></span>
				<img src="/images/Payguide/PayGuide-2.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide3"></span>
				<img src="/images/Payguide/PayGuide-3.jpg" />
				
			</li>
			<li>
				<span class="anchor" id="guide4"></span>
				<img src="/images/Payguide/PayGuide-4.jpg" />
				
			</li>
			<li>
				<span class="anchor" id="guide5"></span>
				<img src="/images/Payguide/PayGuide-5.jpg"/>
				
			</li>
			<li>
				<span class="anchor" id="guide6"></span>
				<img src="/images/Payguide/PayGuide-6.jpg" />
				
			</li>
			<li>
				<span class="anchor" id="guide7"></span>
				<img src="/images/Payguide/PayGuide-7.jpg"/>
				
			</li>
		</div>


  
    </div>
    <div style="position: fixed;     left: 88%; top:90%; cursor:pointer">
         <p class="topbtn"><a><span> <img style="" src="/AdminSub/Images/topimg.png" /></span></a></p>
    </div>
</asp:Content>