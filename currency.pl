#!/usr/bin/perl

#written by chris@katipo.co.nz
#9/10/2000
#script to display and update currency rates

use CGI;
use C4::Acquisitions;

my $input=new CGI;

my $type=$input->param('type');
#find out what the script is being called for
#print $input->header();
if ($type ne 'change'){
  #display, we must fetch the exchange rate data and output it
  print $input->header();
  print <<printend
  <TABLE width="40%" cellspacing=0 cellpadding=5 border=1 >
  <FORM ACTION="/cgi-bin/koha/currency.pl">
  <input type=hidden name=type value=change>
  <TR VALIGN=TOP>
  <TD  bgcolor="99cc33" background="/images/background-mem.gif" colspan=2 ><b>EXCHANGE RATES </b></TD></TR>
  <TR VALIGN=TOP>                                                                 
  <TD>
printend
;
  my ($count,$rates)=getcurrencies();
  for (my $i=0;$i<$count;$i++){
    if ($rates->[$i]->{'currency'} ne 'NZD'){
      print "$rates->[$i]->{'currency'}<INPUT TYPE=\"text\"  SIZE=\"5\"   NAME=\"$rates->[$i]->{'currency'}\" value=$rates->[$i]->{'rate'}>";
    }
#    print $rates->[$i]->{'currency'};
  }
  print <<printend
    <p>                                                                             
  <input type=image  name=submit src=/images/save-changes.gif border=0 width=187 height=42>
  
  </TD></TR>                                                                      
  </form>                                                                         
  </table>                                                
printend
;
} else {
#  print $input->Dump;
  my @params=$input->param;
  foreach my $param (@params){
    if ($param ne 'type' && $param !~ /submit/){
      my $data=$input->param($param);
      updatecurrencies($param,$data);
    }
  }
  print $input->redirect('/acquisitions/');
}
