<%@ Control Language="vb" AutoEventWireup="false" Codebehind="savetocsv.ascx.vb" Inherits="DotNetNuke.Modules.Events.savetocsv" %>
<script type="text/javascript">
//javascript:__doPostBack('dnn$ctr372$savetocsv$save','')
</script>

<div align="left">
<asp:LinkButton ID="save" runat="server" Text="Save to Excel"></asp:LinkButton>
<asp:datagrid id="DatagridForSaveToExcel" runat="server" AutoGenerateColumns="False" Visible="True">
	<Columns>
		<asp:BoundColumn DataField="Username" HeaderText="UserName"></asp:BoundColumn>
        <asp:BoundColumn DataField="Realname" HeaderText="Real Name"></asp:BoundColumn>
		<asp:BoundColumn DataField="Email" HeaderText="Email"></asp:BoundColumn>
		<asp:BoundColumn DataField="Telephone" HeaderText="Telephone"></asp:BoundColumn>
		<asp:BoundColumn DataField="AltTelephone" HeaderText="Alt Telephone"></asp:BoundColumn>
		<asp:BoundColumn DataField="EmContactName" HeaderText="Em Name"></asp:BoundColumn>
		<asp:BoundColumn DataField="EmContactPhone" HeaderText="Em Telephone"></asp:BoundColumn>
		<asp:BoundColumn DataField="EmContactDetails" HeaderText="Em Details"></asp:BoundColumn>
		<asp:BoundColumn DataField="UserName" HeaderText="Enrolled Participants"></asp:BoundColumn>
		<asp:BoundColumn DataField="Cwaiver" HeaderText="Lastest Waiver"></asp:BoundColumn>
		<asp:BoundColumn DataField="ACAnum" HeaderText="ACA#"></asp:BoundColumn>
		<asp:BoundColumn DataField="ACA_Exp" HeaderText="ACA Exp"></asp:BoundColumn>
		<asp:BoundColumn DataField="WaiverCurrent" HeaderText="Waiver Current"></asp:BoundColumn>
		<asp:BoundColumn DataField="PACKMembershipCurrent" HeaderText="PACK Membership Current"></asp:BoundColumn>
		<asp:BoundColumn DataField="ACAMembershipCurrent" HeaderText="ACA Membership Current"></asp:BoundColumn>
		<asp:BoundColumn DataField="Notes" HeaderText="Notes"></asp:BoundColumn>
	</Columns>
</asp:datagrid>
</div>