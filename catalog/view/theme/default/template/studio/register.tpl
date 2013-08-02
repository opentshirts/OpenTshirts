<div style="height:550px;">
  <?php if ($error_warning) { ?>
  <div class="ui-state-error ui-corner-all is_ml" ml_label="error_warning"  style="padding:5px; margin:5px; "><?php echo $error_warning; ?></div>
  <?php } ?>
  <div align="right"><a id="btn_register_back"  class="small_link"><span class="is_ml" ml_label="button_back"><?php echo $button_back; ?></span></a></div>
  <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="register">
    <input type="hidden" value="" name="company_id">
    <input type="hidden" value="" name="tax_id">
    <input type="hidden" value="" name="address_2">
    <h2 class="is_ml" ml_label="text_your_details" style="margin-top:0px;"><?php echo $text_your_details; ?></h2>
    <div>
      <table cellpadding="2" cellspacing="1">
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_firstname"><?php echo $entry_firstname; ?></span></td>
          <td><input type="text" name="firstname" value="<?php echo $firstname; ?>" />
            <?php if ($error_firstname) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_firstname"><?php echo $error_firstname; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_lastname"><?php echo $entry_lastname; ?></span></td>
          <td><input type="text" name="lastname" value="<?php echo $lastname; ?>" />
            <?php if ($error_lastname) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_lastname"><?php echo $error_lastname; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_email"><?php echo $entry_email; ?></span></td>
          <td><input type="text" name="email" value="<?php echo $email; ?>" />
            <?php if ($error_email) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_email"><?php echo $error_email; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_telephone"><?php echo $entry_telephone; ?></span></td>
          <td><input type="text" name="telephone" value="<?php echo $telephone; ?>" />
            <?php if ($error_telephone) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_telephone"><?php echo $error_telephone; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span class="is_ml" ml_label="entry_fax"><?php echo $entry_fax; ?></span></td>
          <td><input type="text" name="fax" value="<?php echo $fax; ?>" />
            <?php if ($error_fax) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_fax"><?php echo $error_fax; ?></span>
            <?php } ?></td>
        </tr>
      </table>
    </div>
    <h2 class="is_ml" ml_label="text_your_address"><?php echo $text_your_address; ?> </h2>
    <div>
      <table cellpadding="2" cellspacing="1">
        <tr>
          <td><span><?php echo $entry_company; ?></span></td>
          <td><input type="text" name="company" value="<?php echo $company; ?>" /></td>
        </tr>
        <tr>
          <td><span class="required">*</span> <span><?php echo $entry_address_1; ?></span></td>
          <td><input type="text" name="address_1" value="<?php echo $address_1; ?>" />
            <?php if ($error_address_1) { ?>
            <span class="ui-state-error ui-corner-all msg-padding"><?php echo $error_address_1; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_city"><?php echo $entry_city; ?></span></td>
          <td><input type="text" name="city" value="<?php echo $city; ?>" />
            <?php if ($error_city) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_city"><?php echo $error_city; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_postcode"><?php echo $entry_postcode; ?></span></td>
          <td><input type="text" name="postcode" value="<?php echo $postcode; ?>" />
            <?php if ($error_postcode) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_postcode"><?php echo $error_postcode; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_country"><?php echo $entry_country; ?></span></td>
          <td><select name="country_id" onchange="$('select[name=\'zone_id\']').load('index.php?route=studio/register/zone&country_id=' + this.value + '&zone_id=<?php echo $zone_id; ?>');">
              <option value=""><?php echo $text_select; ?></option>
              <?php foreach ($countries as $country) { ?>
              <?php if ($country['country_id'] == $country_id) { ?>
              <option value="<?php echo $country['country_id']; ?>" selected="selected"><?php echo $country['name']; ?></option>
              <?php } else { ?>
              <option value="<?php echo $country['country_id']; ?>"><?php echo $country['name']; ?></option>
              <?php } ?>
              <?php } ?>
            </select>
            <?php if ($error_country) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_country"><?php echo $error_country; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_zone"><?php echo $entry_zone; ?></span></td>
          <td><select name="zone_id">
            </select>
            <?php if ($error_zone) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_zone"><?php echo $error_zone; ?></span>
            <?php } ?></td>
        </tr>
      </table>
    </div>
    <h2 class="is_ml" ml_label="text_your_password"><?php echo $text_your_password; ?></h2>
    <div>
      <table cellpadding="2" cellspacing="1">
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_password"><?php echo $entry_password; ?></span></td>
          <td><input type="password" name="password" value="<?php echo $password; ?>" />
            <?php if ($error_password) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_password"><?php echo $error_password; ?></span>
            <?php } ?></td>
        </tr>
        <tr>
          <td><span class="required">*</span> <span class="is_ml" ml_label="entry_confirm"><?php echo $entry_confirm; ?></span></td>
          <td><input type="password" name="confirm" value="<?php echo $confirm; ?>" />
            <?php if ($error_confirm) { ?>
            <span class="ui-state-error ui-corner-all msg-padding  is_ml" ml_label="error_confirm"><?php echo $error_confirm; ?></span>
            <?php } ?></td>
        </tr>
      </table>
    </div>
    <div align="right"  style="margin-top:15px;"><a id="btn_register_continue"><span class="is_ml" ml_label="button_continue"><?php echo $button_continue; ?></span></a></div>
  </form>
</div>
<script type="text/javascript"><!--
//-->
$(function() {
	$('select[name=\'zone_id\']').load('index.php?route=studio/register/zone&country_id=<?php echo $country_id; ?>&zone_id=<?php echo $zone_id; ?>');
	$('#register').submit(function(event) {
		/* stop form from submitting normally */
		event.preventDefault(); 
		loadPopUp('<?php echo $action; ?>', $('#register').serialize(), "POST" );
		return false;
	});
	$( "#btn_register_continue" ).button()
	.click(function() {
		$('#register').submit();
	});
	$( "#btn_register_back" ).click(function() {
		loadPopUp('<?php echo $back; ?>' );
	});
	
	

});
</script>