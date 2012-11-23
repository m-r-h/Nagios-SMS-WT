Nagios-SMS-WT
=============

Plugin for Nagios to send SMS Text Message notifications via world-text.com

ACCOUNTID and APIKEY are obtained from within your World-Text.com account page.
Replace with the values from there.

Define two commands notify-by-sms and host-notify-by-sms as follows

	define command { 
	        command_name notify-by-sms 
	        command_line $USER1$/notify_worldtext_sms.pl -i ACCOUNTID -k APIKEY -d $CONTACTPAGER$ -t "NOTIFICATIONTYPE$ $SERVICESTATE$ $SERVICEDESC$ Host($HOSTNAME$) Info($SERVICEOUTPUT$) Date($SHORTDATETIME$)" 
	} 
	
	define command { 
	        command_name host-notify-by-sms 
	        command_line $USER1$/notify_worldtext_sms.pl -i ACCOUNTID -k APIKEY -d $CONTACTPAGER$ -t "$NOTIFICATIONTYPE$ $HOSTSTATE$ Host($HOSTALIAS$) Info($HOSTOUTPUT$) Time($SHORTDATETIME$)" 
	}



In your contacts add the field "pager" with the contact's mobile number in
full international format e.g.

	define contact{
	        contact_name                    engineer
	        alias                           Support Engineer
	        service_notification_period     24x7
	        host_notification_period        24x7
	        service_notification_options    w,u,c,r
	        host_notification_options       d,u,r
	        service_notification_commands   notify-by-email,notify-by-sms
	        host_notification_commands      host-notify-by-email,host-notify-by-sms
	        email                           engineer@mydomain.com
	        pager                           447987xxxxxx
	}


