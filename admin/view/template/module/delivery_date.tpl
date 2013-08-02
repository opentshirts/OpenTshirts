<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a><a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $button_cancel; ?></a></div>
    </div>
    <div class="content">
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <table class="form">
            <tr>
              <td><?php echo $entry_skip_days; ?></td>
              <td><input type="checkbox" name="delivery_date_skip[Mon]" value="1" <?php if (isset($delivery_date_skip['Mon'])) { ?> checked="checked" <?php } ?> />
                <?php echo $text_monday; ?>
              </td>
              <td><input type="checkbox" name="delivery_date_skip[Tue]" value="1" <?php if (isset($delivery_date_skip['Tue'])) { ?> checked="checked" <?php } ?> />
                <?php echo $text_tuesday; ?>
              </td>
              <td><input type="checkbox" name="delivery_date_skip[Wed]" value="1" <?php if (isset($delivery_date_skip['Wed'])) { ?> checked="checked" <?php } ?> />
                <?php echo $text_wednesday; ?>
              </td>
              <td><input type="checkbox" name="delivery_date_skip[Thu]" value="1" <?php if (isset($delivery_date_skip['Thu'])) { ?> checked="checked" <?php } ?> />
                <?php echo $text_thursday; ?>
              </td>
              <td><input type="checkbox" name="delivery_date_skip[Fri]" value="1" <?php if (isset($delivery_date_skip['Fri'])) { ?> checked="checked" <?php } ?> />
                <?php echo $text_friday; ?>
              </td>
              <td><input type="checkbox" name="delivery_date_skip[Sat]" value="1" <?php if (isset($delivery_date_skip['Sat'])) { ?> checked="checked" <?php } ?> />
                <?php echo $text_saturday; ?>
              </td>
              <td><input type="checkbox" name="delivery_date_skip[Sun]" value="1" <?php if (isset($delivery_date_skip['Sun'])) { ?> checked="checked" <?php } ?> />
                <?php echo $text_sunday; ?>
              </td>
            </tr>
        </table>
        <table class="form">
            <tr>
              <td><?php echo $entry_rush_title; ?></td>
              <td><input type="text" name="delivery_date_rush_title" value="<?php echo $delivery_date_rush_title; ?>" size="80" /></td>
            </tr>
            <tr>
              <td><?php echo $entry_free_title; ?></td>
              <td><input type="text" name="delivery_date_free_title" value="<?php echo $delivery_date_free_title; ?>" size="80" /></td>
            </tr>
        </table>
        <table id="module" class="list">
          <thead>
            <tr>
              <td class="left"><?php echo $entry_days_rush ?></td>
              <td class="left"><?php echo $entry_days_free; ?></td>
              <td class="left"><?php echo $entry_shipping_link; ?></td>
              <td class="left"><?php echo $entry_layout; ?></td>
              <td class="left"><?php echo $entry_position; ?></td>
              <td class="left"><?php echo $entry_status; ?></td>
              <td class="right"><?php echo $entry_sort_order; ?></td>
              <td></td>
            </tr>
          </thead>
          <?php $module_row = 0; ?>
          <?php foreach ($modules as $module) { ?>
          <tbody id="module-row<?php echo $module_row; ?>">
            <tr>
              <td class="left"><input type="text" name="delivery_date_module[<?php echo $module_row; ?>][days_rush]" value="<?php echo $module['days_rush']; ?>" size="3" /></td>
              <td class="left"><input type="text" name="delivery_date_module[<?php echo $module_row; ?>][days_free]" value="<?php echo $module['days_free']; ?>" size="3" /></td>
              <td class="left"><input type="text" name="delivery_date_module[<?php echo $module_row; ?>][shipping_link]" value="<?php echo $module['shipping_link']; ?>" size="80" /></td>
              <td class="left"><select name="delivery_date_module[<?php echo $module_row; ?>][layout_id]">
                  <?php foreach ($layouts as $layout) { ?>
                  <?php if ($layout['layout_id'] == $module['layout_id']) { ?>
                  <option value="<?php echo $layout['layout_id']; ?>" selected="selected"><?php echo $layout['name']; ?></option>
                  <?php } else { ?>
                  <option value="<?php echo $layout['layout_id']; ?>"><?php echo $layout['name']; ?></option>
                  <?php } ?>
                  <?php } ?>
                </select></td>
              <td class="left"><select name="delivery_date_module[<?php echo $module_row; ?>][position]">
                  <?php if ($module['position'] == 'content_top') { ?>
                  <option value="content_top" selected="selected"><?php echo $text_content_top; ?></option>
                  <?php } else { ?>
                  <option value="content_top"><?php echo $text_content_top; ?></option>
                  <?php } ?>
                  <?php if ($module['position'] == 'content_bottom') { ?>
                  <option value="content_bottom" selected="selected"><?php echo $text_content_bottom; ?></option>
                  <?php } else { ?>
                  <option value="content_bottom"><?php echo $text_content_bottom; ?></option>
                  <?php } ?>
                  <?php if ($module['position'] == 'column_left') { ?>
                  <option value="column_left" selected="selected"><?php echo $text_column_left; ?></option>
                  <?php } else { ?>
                  <option value="column_left"><?php echo $text_column_left; ?></option>
                  <?php } ?>
                  <?php if ($module['position'] == 'column_right') { ?>
                  <option value="column_right" selected="selected"><?php echo $text_column_right; ?></option>
                  <?php } else { ?>
                  <option value="column_right"><?php echo $text_column_right; ?></option>
                  <?php } ?>
                </select></td>
              <td class="left"><select name="delivery_date_module[<?php echo $module_row; ?>][status]">
                  <?php if ($module['status']) { ?>
                  <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                  <option value="0"><?php echo $text_disabled; ?></option>
                  <?php } else { ?>
                  <option value="1"><?php echo $text_enabled; ?></option>
                  <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                  <?php } ?>
                </select></td>
              <td class="right"><input type="text" name="delivery_date_module[<?php echo $module_row; ?>][sort_order]" value="<?php echo $module['sort_order']; ?>" size="3" /></td>
              <td class="left"><a onclick="$('#module-row<?php echo $module_row; ?>').remove();" class="button"><?php echo $button_remove; ?></a></td>
            </tr>
          </tbody>
          <?php $module_row++; ?>
          <?php } ?>
          <tfoot>
            <tr>
              <td colspan="7"></td>
              <td class="left"><a onclick="addModule();" class="button"><?php echo $button_add_module; ?></a></td>
            </tr>
          </tfoot>
        </table>
        <h4><?php echo $text_holiday; ?></h4>
        <table id="holiday" class="list">
          <thead>
            <tr>
              <td class="left"><?php echo $entry_holiday_month; ?></td>
              <td class="left"><?php echo $entry_holiday_day; ?></td>
              <td class="left"><?php echo $entry_reason; ?></td>
              <td></td>
            </tr>
          </thead>
          <?php $holiday_row = 0; ?>
          <?php foreach ($delivery_date_holidays as $holiday) { ?>
          <tbody id="holiday-row<?php echo $holiday_row; ?>">
            <tr>
                <td class="left"><select name="delivery_date_holidays[<?php echo $holiday_row; ?>][month]">
                  <?php for ($i = 1; $i <= 12; $i++) { ?>
                    <?php if($i == $holiday['month']) { ?>
                    <option value="<?php echo $i; ?>" selected="selected"><?php echo $i; ?></option>
                    <?php } else { ?>
                    <option value="<?php echo $i; ?>"><?php echo $i; ?></option>
                    <?php } ?>
                  <?php } ?>
                </select></td>
              <td class="left"><select name="delivery_date_holidays[<?php echo $holiday_row; ?>][day]">
                  <?php for ($i = 1; $i <= 31; $i++) { ?>
                    <?php if($i == $holiday['day']) { ?>
                    <option value="<?php echo $i; ?>" selected="selected"><?php echo $i; ?></option>
                    <?php } else { ?>
                    <option value="<?php echo $i; ?>"><?php echo $i; ?></option>
                    <?php } ?>
                  <?php } ?>
                </select></td>
              <td class="left"><input type="text" name="delivery_date_holidays[<?php echo $holiday_row; ?>][reason]" value="<?php echo $holiday['reason']; ?>" size="80" /></td>
              <td class="left"><a onclick="$('#holiday-row<?php echo $holiday_row; ?>').remove();" class="button"><?php echo $button_remove; ?></a></td>
            </tr>
          </tbody>
          <?php $holiday_row++; ?>
          <?php } ?>
          <tfoot>
            <tr>
              <td colspan="3"></td>
              <td class="left"><a onclick="addHoliday();" class="button"><?php echo $button_add_module; ?></a></td>
            </tr>
          </tfoot>
        </table>
      </form>
    </div>
  </div>
</div>
<script type="text/javascript"><!--
var module_row = <?php echo $module_row; ?>;

function addModule() {  
  html  = '<tbody id="module-row' + module_row + '">';
  html += '  <tr>';
  html += '    <td class="left"><input type="text" name="delivery_date_module[' + module_row + '][days_rush]" value="2" size="3" /></td>';
  html += '    <td class="left"><input type="text" name="delivery_date_module[' + module_row + '][days_free]" value="14" size="3" /></td>';  
  html += '    <td class="left"><input type="text" name="delivery_date_module[' + module_row + '][shipping_link]" value="index.php?route=information/information&information_id=6" size="80" /></td>'; 
  html += '    <td class="left"><select name="delivery_date_module[' + module_row + '][layout_id]">';
  <?php foreach ($layouts as $layout) { ?>
  html += '      <option value="<?php echo $layout['layout_id']; ?>"><?php echo addslashes($layout['name']); ?></option>';
  <?php } ?>
  html += '    </select></td>';
  html += '    <td class="left"><select name="delivery_date_module[' + module_row + '][position]">';
  html += '      <option value="content_top"><?php echo $text_content_top; ?></option>';
  html += '      <option value="content_bottom"><?php echo $text_content_bottom; ?></option>';
  html += '      <option value="column_left"><?php echo $text_column_left; ?></option>';
  html += '      <option value="column_right"><?php echo $text_column_right; ?></option>';
  html += '    </select></td>';
  html += '    <td class="left"><select name="delivery_date_module[' + module_row + '][status]">';
    html += '      <option value="1" selected="selected"><?php echo $text_enabled; ?></option>';
    html += '      <option value="0"><?php echo $text_disabled; ?></option>';
    html += '    </select></td>';
  html += '    <td class="right"><input type="text" name="delivery_date_module[' + module_row + '][sort_order]" value="" size="3" /></td>';
  html += '    <td class="left"><a onclick="$(\'#module-row' + module_row + '\').remove();" class="button"><?php echo $button_remove; ?></a></td>';
  html += '  </tr>';
  html += '</tbody>';
  
  $('#module tfoot').before(html);
  
  module_row++;
}
//--></script> 
<script type="text/javascript"><!--
var holiday_row = <?php echo $holiday_row; ?>;

function addHoliday() {  
  html  = '<tbody id="holiday-row' + holiday_row + '">';
  html += '  <tr>';
html += '    <td class="left"><select name="delivery_date_holidays[' + holiday_row + '][month]">';
  <?php for ($i = 1; $i <= 12; $i++) { ?>
  html += '      <option value="<?php echo $i; ?>"><?php echo $i; ?></option>';
  <?php } ?>
  html += '    </select></td>';
  html += '    <td class="left"><select name="delivery_date_holidays[' + holiday_row + '][day]">';
  <?php for ($i = 1; $i <= 31; $i++) { ?>
  html += '      <option value="<?php echo $i; ?>"><?php echo $i; ?></option>';
  <?php } ?>
  html += '    </select></td>';
  html += '    <td class="left"><input type="text" name="delivery_date_holidays[' + holiday_row + '][reason]" value="" size="200" /></td>'; 
  html += '    <td class="left"><a onclick="$(\'#holiday-row' + holiday_row + '\').remove();" class="button"><?php echo $button_remove; ?></a></td>';
  html += '  </tr>';
  html += '</tbody>';
  
  $('#holiday tfoot').before(html);
  
  holiday_row++;
}
//--></script> 
<?php echo $footer; ?>