<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="CScenterMain.aspx.cs" Inherits="CustomerService_CScenterMain" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

	<style>
		#CS_content{border:1px solid #a2a2a2; width:100%; height:960px; margin-top:30px; }
		.sale_member{width:588px; height:300px; border:1px solid #e5e5e5; float:left; margin:10px 10px}
		.CS_photo{float:left}
		.CS_photo img{ width:270px; height:270px; margin:13px 10px; border:1px solid #a2a2a2; box-sizing:border-box }
		.CS_info{ width:270px; height:270px; margin:13px 10px; float:left; list-style:none;}
		.CS_info li{width:100%; height:45px; border-bottom:1px dotted #a2a2a2;  font-size:14px; font-family:Dotum; line-height:48px;  padding-left:10px; }
	</style>

	
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


	<div class="sub-contents-div">
			<div class="sub-title-div"><img src="../Images/CS/csCenter.jpg" alt="고객센터"/></div>

<!--탭메뉴-->          
            <div class="sub-tab-div1" style="margin-left:-40px">
	    		<ul>
		    		<li>
			    		<a href="CScenterSalesDept.aspx"><img src="../Images/CS/saleDept-off.jpg" alt="영업"/></a>
						<a href="CScenterMD.aspx"><img src="../Images/CS/MD-off.jpg" alt="MD"/></a>
						<a href="CScenterMain.aspx"><img src="../Images/CS/CS.jpg" alt="CS센터"/></a>
				    	
                        
				    </li>
			    </ul>
	         </div>

			<div id="CS_content">

				<div class="sale_member">
					<div class="CS_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="CS_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>

				<div class="sale_member">
					<div class="CS_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="CS_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>
				
				<div class="sale_member">
					<div class="CS_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="CS_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>

				<div class="sale_member">
					<div class="CS_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="CS_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>

				<div class="sale_member">
					<div class="CS_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="CS_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>

				<div class="sale_member">
					<div class="CS_photo">
						<img src="../images/CS/no_image.jpg">
					</div>
					<div class="CS_info">
						<li><b>이 름 :</b></li>
						<li><b>직 급 :</b></li>
						<li><b>전화번호 :</b></li>
						<li><b>휴대전화 :</b></li>
						<li><b>팩 스 :</b></li>
						<li><b>E-mail :</b><a href="#"><b></b></a></li>
					</div>		
				</div>

			</div>



		</div>





</asp:Content>

