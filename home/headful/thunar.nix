{ config, lib, pkgs, ... }: {
  home.activation.clearThunar = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    $DRY_RUN_CMD rm -f $VERBOSE_ARG \
        ${config.xdg.configHome}/xfce4/xfconf/xfce-perchannel-xml/thunar.xml \
        ${config.xdg.configHome}/Thunar/uca.xml \
        ${config.xdg.configHome}/gtk-3.0/bookmarks
  '';
  home.file."${config.xdg.configHome}/xfce4/xfconf/xfce-perchannel-xml/thunar.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>

    <channel name="thunar" version="1.0">
      <property name="default-view" type="string" value="ThunarDetailsView"/>
      <property name="misc-directory-specific-settings" type="bool" value="true"/>
      <property name="misc-thumbnail-mode" type="string" value="THUNAR_THUMBNAIL_MODE_ALWAYS"/>
      <property name="misc-date-style" type="string" value="THUNAR_DATE_STYLE_YYYYMMDD"/>
      <property name="misc-middle-click-in-tab" type="bool" value="true"/>
      <property name="misc-show-delete-action" type="bool" value="true"/>
      <property name="misc-parallel-copy-mode" type="string" value="THUNAR_PARALLEL_COPY_MODE_ONLY_LOCAL_SAME_DEVICES"/>
      <property name="misc-transfer-use-partial" type="string" value="THUNAR_USE_PARTIAL_MODE_ALWAYS"/>
      <property name="last-location-bar" type="string" value="ThunarLocationButtons"/>
      <property name="last-image-preview-visible" type="bool" value="true"/>
      <property name="last-toolbar-item-order" type="string" value="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17"/>
      <property name="last-toolbar-visible-buttons" type="string" value="0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1,0"/>
      <property name="last-show-hidden" type="bool" value="true"/>
      <property name="last-details-view-column-order" type="string" value="THUNAR_COLUMN_NAME,THUNAR_COLUMN_TYPE,THUNAR_COLUMN_LOCATION,THUNAR_COLUMN_MIME_TYPE,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_SIZE_IN_BYTES,THUNAR_COLUMN_RECENCY,THUNAR_COLUMN_DATE_ACCESSED,THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_DATE_CREATED,THUNAR_COLUMN_OWNER,THUNAR_COLUMN_GROUP,THUNAR_COLUMN_PERMISSIONS,THUNAR_COLUMN_DATE_DELETED"/>
      <property name="last-details-view-visible-columns" type="string" value="THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_GROUP,THUNAR_COLUMN_NAME,THUNAR_COLUMN_OWNER,THUNAR_COLUMN_PERMISSIONS,THUNAR_COLUMN_SIZE"/>
      <property name="misc-folder-item-count" type="string" value="THUNAR_FOLDER_ITEM_COUNT_ALWAYS"/>
      <property name="hidden-bookmarks" type="array">
        <value type="string" value="computer:///"/>
        <value type="string" value="network:///"/>
      </property>
    </channel>
  '';
  home.file."${config.xdg.configHome}/Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
    <action>
      <icon>utilities-terminal</icon>
      <name>Open Terminal Here</name>
      <submenu></submenu>
      <unique-id>1674816398934802-1</unique-id>
      <command>alacritty --working-directory %f</command>
      <description>Open a terminal at this directory</description>
      <range></range>
      <patterns>*</patterns>
      <startup-notify/>
      <directories/>
    </action>
    </actions>
  '';
  home.file."${config.xdg.configHome}/gtk-3.0/bookmarks".text = ''
    file:///home/noah/tmp Temporary
    file:///home/noah/download Downloads
    file:///home/noah/org Organisation
    file:///home/noah/doc Documents
    file:///home/noah/audio Audio
    file:///home/noah/visual Visual
    file:///home/noah/app Applications
    file:///home/noah/game Games
    file:///home/noah/jail Jail
  '';
}
