<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="CScenterMD.aspx.cs" Inherits="AdminSub_CustomerService_CScenterMD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

	<style>
		#CS_content{border:1px solid #a2a2a2; width:100%; height:960px; margin-top:30px; }
		.sale_member{width:588px; height:300px; border:1px solid #e5e5e5; float:left; margin:10px 10px}
		.MD_photo{float:left}
		.MD_photo img{ width:270px; height:270px; margin:13px 10px; border:1px solid #a2a2a2; box-sizing:border-box }
		.MD_info{ width:270px; height:270px; margin:13px 10px; float:left; list-style:none;}
		.MD_info li{width:100%; height:38px; border-bottom:1px dotted #a2a2a2;  font-size:14px; font-family:Dotum; line-height:40px;  padding-left:10px; }
	</style>


    <link href="../Contents/Goods/as.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {

             $('.div-main-tab > ul > li').click(function () {
                if ($(this).attr('id') == 'lisa') {
                    $(this).attr('onClick', "location.href='CScenterSalesDept.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'CScenterSalesDept.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'limd') {
                    $(this).attr('onClick', "location.href='CScenterMD.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'CScenterMD.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lics') {
                    $(this).attr('onClick', "location.href='CScenterMain.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'CScenterMain.aspx?ucode='+ucode+'');
                }
            })
        })
    </script>

    <div class="all">
     <div class="sub-contents-div">
        <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    고객센터
                    <span class="span-title-subsentence">담당자의 연락처를 확인 할 수 있습니다.</span>
                </p>
            </div>
          <div style="height:30px;"></div>
            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li id="lics" class='tabOff' style="width: 185px;">
                        <a>CS센터</a>
                     </li>
                    <li id="lisa"  class='tabOff' style="width: 185px;">
                        <a>영업</a>
                    </li>
                    <li id="limd" class='tabOn' style="width: 185px;">
                        <a>MD</a>
                     </li>
                    
                </ul>
            </div>
		
		<div id="CS_content">

			<div class="sale_member">
					<div class="MD_photo">
						<img src="../images/CS/MD_Member1.jpg">
					</div>
					<div class="MD_info">
						<li><b>이 름 :</b> 한훈희</li>
						<li><b>직 급 :</b> 대 리</li>
						<li><b>관리상품군 :</b> </li>
						<li><b>전화번호 :</b> 02-6363-2712</li>
						<li><b>휴대전화 :</b> 010-5758-1017</li>
						<li><b>팩 스 :</b> 02-6332-2180</li>
						<li><b>E-mail :</b><a href="mailto:uri014@uri-an.com"><b>uri014@uri-an.com</b></a></li>
					</div>
				</div>


				<div class="sale_member">
					<div class="MD_photo">
						<img src="../images/CS/MD_Member2.jpg">
					</div>
					<div class="MD_info">
						<li><b>이 름 :</b>이민규</li>
						<li><b>직 급 :</b>대 리</li>
						<li><b>관리상품군 :</b> </li>
						<li><b>전화번호 :</b> 02-6363-2711</li>
						<li><b>휴대전화 :</b> 010-7164-8565</li>
						<li><b>팩 스 :</b> 02-6332-2180</li>
						<li><b>E-mail :</b><a href="mailto:uri015@uri-an.com"><b>uri015@uri-an.com</b></a></li>
					</div>
						
				</div>

				<div class="sale_member">
					<div class="MD_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="MD_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>관리상품군 :</b> </li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>

				<div class="sale_member">
					<div class="MD_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="MD_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>관리상품군 :</b> </li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>

				<div class="sale_member">
					<div class="MD_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="MD_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>관리상품군 :</b> </li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>

				<div class="sale_member">
					<div class="MD_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="MD_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>관리상품군 :</b> </li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>



		</div>

	</div>

        </div>

</asp:Content>

