          DNN Events Module 3.2.0 for DotNetNuke
			3/10/2006

This is the new Events/Calendar Module for DNN.  This latest version provides many new features.  The Source Code and Private Assembly are available...use at your own risk...we plan many upgrades to this version and will not support customized version!  Please any concerns, issues, kudos, etc. on the DNN Project Events forum (http://www.dotnetnuke.com/Default.aspx?tabid=795).  Thanks for your support!


Features
	- Automated Event Notification (via DNN Scheduler)
	- Implemented Search for the Events
	- Better Event Month and Week View Look and Feel
	- Minor performance enhancements
	- New, improved HTML Tooltip feature, including HTML Tooltip support
	- Ability to turn off/on Event Month View Cell and Event List table (below month view)
	- Improved Fields selectable Event List
	- Support for all previous features of both DNN Events and AVCalendar
	- Events may be entered by TimeZone; Users will view the Event in their current TimeZone setting; Anonymous users will view events in the Portal TimeZone setting
	- Upgrade/Import Events from previous AVCalendar
	- Upgrade of previous DNN Events 3.0.1 module
	- Recurring Events (Daily, Weekly, Monthly, etc.)
	- User Created and Moderated (optionally) Events
	- Unlimited Master/Sub Event Module Rollup (admin defined)
	- Event Enrollment for allowing Authorized Roles (or Authenticated Users) to sign up for an event.  This includes the ability to setup "Paid" enrollments via PayPal. The paid enrollments will automatically authorize paid users to the event and track (in the database) their payments.
	- Users can view their Enrollments
	- Moderation for New Events, Changes to Events, and Event Enrollment.  This feature includes the ability to email users a confirmation along w/a .VCS (Outlook Import) file for the event.
	- Seperate, but related List View of Events module
	- Flexible look and feel customization via settings and module.css
	- Localization Support, including detecting Language Week Start Day (Mon or Sun) and specifying weekends (fri/sat or sat/sun)

The Events Module is built specifically for DotNetNuke 3.0.13 and above (www.dotnetnuke.com). 


The Event module has a flexible security architecture where you authorize members of a DNN Role to add/edit there own events (but not others).  To use this feature, simply add the role as editors in the DNN Module definition.  The module uses intellegence to determine if the event was created by the user when editing is requested.

To use the new Moderation feature, simply pull up the Admin Options form and assign a DNN Role to the Moderator (the Admin account automatically has ALL Permissions).  Members of this role will then be able to add, edit, and delete ALL Events for the module.  Also, all new events entered by others (except the Moderator and Admin roles) must be approved before they will be displayed on the event.  Optionally, you can require that every change (edits of events by users) be authorized by the moderator.  Moderators DO NOT have the ability to change the Event Settings (only Administrators can perform this task).  Moderators and Administrators can Delete Events...However, users will not be able to delete events.

Master Event/Sub Event module rollups are supported.  In other words, when you setup a Event module, the Portal Admin can define Sub Event modules to be included and rolled up to the Master Event module...The rollup is supported for unlimited levels!!!  However, please consider performance may be effected. Permissions on the Master Event module are independent of the permissions on the Sub Event modules.


Known Issues:

1) If you change the default (30 minute interval) on the Admin Options and include the Sub Event module on a Master Event module, the Time Interval for the Master Event module must be the same.


Instructions:

1) Moderated Events:

The Site Admin has all rights on all Events by default (Edit, Moderate, etc).  The "Moderate ALL Event Changes" must be turned on in the "Admin Option" for the moderate function to work (exception - see Free Enrollment below).

Create a Moderator Role on the Site (ex.Event Moderator).  On the Admin Options for the selected Event(s) set the Moderator Role to this Role.

Once this is turned on, a User in the Moderator Role (or the Site Admin) must logon and approve All new events/enrollment (except events created by Admin or Moderator Role Users - auto approved).  The Event will not show on any modules until approved by the Admin or Moderator!

Use the "Moderate Event" option to moderate both New/Updated Events and newly Enrolled (free/moderated) Users.  In order to moderate enrollments, you must select the "Enrollments" option at the top...If events/enrollments need to be approved, they will be displayed and a grid.  Select the individual items and approve, deny, or delete.  You may also broadcast and email to the individuals that created an event/enrolled.  If approved, the event will now display on the module or the enrollment will be listed as approved on the event edit form.


2) Enroll Events

First there are two types of Enroll, free and paid. The "Permit Event Enrollment" option must be turned on in the "Settings" for the module to permit Enrollment.

All Free Enrollments must be moderated...in other words approved via the "Moderate Event" form, regardless of the "moderation option" on the Admin Options. 

In order to set the event up as an Enrollment Event, select the "Allow Enrollment" checkbox on the event edit form.  If you do not wish to charge for the event and collect payment via paypal, that's all you need to do.

Users will be able to select the event and view the details.  On the Event Detail form they will be presented with an option to Enroll for Event", if they have not already enrolled.  Once selected, they will be returned to the main Event view.  If they return to the detail view they will be able to see the status of their enrollment (approved/denied).

On the Event Edit, you may also limit the number of registrations. Put an integer in the "Max. Enrollment" field representing the total enrollment allowed for either free or paid events.

You can also limit the enrollment to a specific role on the Site. Select the role on the "Enrollment Role" dropdown.  If not selected, only "Registered" Users will be allowed to enroll.

Paid events easy to setup but require a PayPal account for both the Enrollee and the Event Adminstrator.  They essentially work the same, except are not moderated (their payment is the moderation - i.e. show me the money).  They may also be limited by event site (number of seats) and by site roll.

At any time, thje event creator can pull up the edit event form and view the enrollees and their status.  An email message can be broadcast to all enrollees.

3) Security - The security for the module has been designed and tested to support four main roles:
  a) Admin - by default the Admin role for the site can perform all functions for the module: admin, moderate, edit/view/delete all events
  b) Moderator - this role must be assigned to the Event module on the Admin Options.  Users assigned to this role will have Moderate (events/enrollment approval), edit/view/delete all events
  c) Editor - this role is assigned on the Module/Page settings, any user assigned to this role will have edit/delete to events that they create and view to all other events
  d) Anonymous - all users with module/page view access will have the ability to view the month, including week view and details




Installation:
   
  This is a DotNetNuke Private Assembly.  Go to the DNN File uploader as the DNN Host Admin (see DotNetNuke instructions).  Select File Type 'Module'.  Add the Events 3.2.0 PA.ZIP file, Select Add, then press Upload.  This will load the application and install the Database Changes.  You should now be able to add the "Events module" to a DNN Page.  WARNING: If you delete the module from the DNN "Module Definitions", all data tables and stored procedures will also be deleted.


Please continue report any bugs, issues, or feature requests on the DotNetNuke Events forum (www.dotnetnuke.com)
