<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="CScenterMD.aspx.cs" Inherits="CustomerService_CScenterMD" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

	<style>
		#CS_content{border:1px solid #a2a2a2; width:100%; height:368px; margin-top:30px; }
		.sale_member{width:588px; height:345px; border:1px solid #a2a2a2; float:left; margin:10px 10px}
		.MD_photo{float:left}
		.MD_photo img{ width:270px; height:270px; margin:20px 10px; border:1px solid #a2a2a2; box-sizing:border-box }
		.MD_info{ width:270px; height:270px; margin:13px 10px; float:left; list-style:none;}
		.MD_info li{width:100%; height:auto; border-bottom:1px dotted #a2a2a2;  font-size:12px; font-family:Dotum; line-height:40px;  padding-left:10px; }
	</style>


   
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
	<div class="sub-contents-div">
       <div class="sub-title-div">
	        <p class="p-title-mainsentence">
                       고객센터
                       <span class="span-title-subsentence">담당자의 연락처를 확인 할 수 있습니다.</span>
            </p>
         </div>

<!--탭메뉴-->          
            <div class="sub-tab-div1" style="margin-left:-40px">
	    		<ul>
		    		<li>
			    		<a href="CScenterSalesDept.aspx"><img src="../Images/CS/saleDept-off.jpg" alt="영업"/></a>
						<a href="CScenterMD.aspx"><img src="../Images/CS/MD.jpg" alt="MD"/></a>
						<%--<a href="CScenterMain.aspx"><img src="../Images/CS/CS-off.jpg" alt="CS센터"/></a>--%>
				    	
                        
				    </li>
			    </ul>
	         </div>
		
		<div id="CS_content">
            <%--<div class="sale_member">
					<div class="MD_photo">
						<img src="../Images/CS/no_image.jpg" alt=""/>
					</div>
					<div class="MD_info">
						<li><b>이 름 :</b> 한태환</li>
						<li><b>직 급 :</b> 과장</li>
						<li style="line-height:20px"><b>관리상품군 :</b> 산업안전용품, 작업/용접/연마, 에어/유압, 절삭/금형/공작, 운반/하역/포장 </li>
						<li><b>전화번호 :</b> 02-6363-2170</li>
						<li><b>휴대전화 :</b> 010-7107-8444</li>
						<li><b>팩 스 :</b> 02-6332-2180</li>
						<li><b>E-mail :</b><a href="mailto:uri019@uri-an.com"><b> uri019@uri-an.com</b></a></li>
					</div>
				</div>--%>




				<div class="sale_member">
					<div class="MD_photo">
						<img src="../images/CS/MD_Member1.jpg">
					</div>
					<div class="MD_info">
						<li><b>이 름 :</b> 한훈희</li>
						<li><b>직 급 :</b> 대 리</li>
						<li style="line-height:20px"><b>관리상품군 :</b> 사무/생활/가전 </li>
						<li><b>전화번호 :</b> 02-6363-2712</li>
						<li><b>휴대전화 :</b> 010-5758-1017</li>
						<li><b>팩 스 :</b> 02-6332-2180</li>
						<li><b>E-mail :</b><a href="mailto:uri014@uri-an.com"><b> uri014@uri-an.com</b></a></li>
					</div>
				</div>


				<div class="sale_member">
					<div class="MD_photo">
						<img src="../images/CS/MD_Member2.jpg">
					</div>
					<div class="MD_info">
						<li><b>이 름 :</b> 이민규</li>
						<li><b>직 급 :</b> 대 리</li>
						<li style="line-height:20px"><b>관리상품군 :</b>  측정/실험기자재, 화학/윤활, 전기/제어/조명, 기계/배관 </li>
						<li><b>전화번호 :</b> 02-6363-2711</li>
						<li><b>휴대전화 :</b> 010-7164-8565</li>
						<li><b>팩 스 :</b> 02-6332-2180</li>
						<li><b>E-mail :</b><a href="mailto:uri015@uri-an.com"><b> uri015@uri-an.com</b></a></li>
					</div>
						
				</div>

			<%--	<div class="sale_member">
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
				</div>--%>


		</div>

	</div>


</asp:Content>

