<%@ Control Language="vb" AutoEventWireup="false" Codebehind="printetails.ascx.vb" Inherits="DotNetNuke.Modules.Events.printdetails" %>
		
<DIV align="center">
	<TABLE id="Table1" cellSpacing="0" cellPadding="3" align="center" width="100%" border="0">
		<TR vAlign="top">
			<TD class="SubHead" colSpan="3">
				<P align="left"><asp:label id="lblTitle" runat="server" CssClass="Head"></asp:label></P>
			</TD>
		</TR>
		<TR vAlign="top">
			<TD class="SubHead" vAlign="top" noWrap width="125">
				<asp:Label id="lblStartDateTime" resourcekey="plStartDateTime" CssClass="SubHead" runat="server">Start Date/Time:</asp:Label></TD>
			<TD vAlign="top" colspan="2" width="100%" noWrap><asp:label id="lblStartDate" runat="server" CssClass="Normal" Width="300px"></asp:label></TD>
		</TR>
		<TR vAlign="top">
			<TD class="SubHead" vAlign="top" noWrap width="125">
				<asp:Label id="lblEndDateTime" resourcekey="plEndDateTime" CssClass="SubHead" runat="server">End Date/Time:</asp:Label>
			</TD>
			<TD vAlign="top" colspan="2" width="100%" noWrap><asp:label id="lblEndDate" runat="server" CssClass="Normal" Width="300px"></asp:label></TD>

		</TR>
		<TR>
			<TD class="SubHead" vAlign="top" noWrap width="125">
				<asp:Label id="plTimeZone" CssClass="SubHead" runat="server" resourcekey="plTimeZone">Time Zone:</asp:Label></TD>
			<TD vAlign="top" colspan="2" width="100%">
				<asp:label id="lblTimeZone" CssClass="Normal" runat="server" Width="300px"></asp:label>&nbsp;&nbsp;&nbsp;
				<asp:dropdownlist id="cboTimeZone" runat="server" Visible="False" Font-Size="8pt" cssclass="NormalTextBox"></asp:dropdownlist></TD>
			
		</TR>
		<TR vAlign="top" runat="server" visible="false">
			<TD class="SubHead" vAlign="top" noWrap width="125">
				<asp:Label Visible="false" id="lblReccuringEvent" CssClass="SubHead" resourcekey="plRecurring" runat="server">Recurring Event:</asp:Label></TD>
			<TD vAlign="top" colspan="2" width="100%"><asp:label Visible="false" id="lblEvent" runat="server" CssClass="Normal"></asp:label></TD>
			
		</TR>
		<TR>
			<TD class="SubHead" vAlign="top" noWrap width="125">
				<asp:label id="lblCategoryCap" resourcekey="plCategory" runat="server" CssClass="SubHead">Category:</asp:label></TD>
			<TD vAlign="top" colspan="2" width="100%">
				<asp:label id="lblCategory" CssClass="Normal" runat="server"></asp:label></TD>
			
		</TR>
		<TR>
			<TD class="SubHead" vAlign="top" noWrap width="125">
				<asp:label id="lblLocationCap" resourcekey="plLocation" runat="server" CssClass="SubHead">Location:</asp:label></TD>
			<TD vAlign="top" colspan="2" width="100%">
				<asp:HyperLink id="hypLocation" runat="server" Target="_blank" CssClass="CommandButton" ToolTip="Select to display map link"></asp:HyperLink></TD>
			
		</TR>
		<TR vAlign="top">
			<TD class="SubHead" vAlign="top" noWrap width="125" colspan="3">
				<asp:Label id="lblDescriptionCap" resourcekey="plDescription" CssClass="SubHead" runat="server">Description:</asp:Label>
			</TD>
			
		</TR>
		<tr vAlign="top">
		<TD vAlign="top" colspan="3">
		<asp:label id="lblDescription" runat="server" CssClass="Normal" ></asp:label>
		</TD>
		</tr>
	</TABLE>
</DIV>
