// this is a very bad implementation for copying reflected data from the CommunityMaterialIcosn class because they hold static fields and not enums. reflection very hard to do with this method

// this goes against idiot proof code

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/widgets.dart';

enum CommunityMaterialIconsEnumMapper {
  cactus(CommunityMaterialIcons.cactus),
  halloween(CommunityMaterialIcons.halloween),
  washing_machine(CommunityMaterialIcons.washing_machine),
  fruit_cherries(CommunityMaterialIcons.fruit_cherries),
  snowflake(CommunityMaterialIcons.snowflake)
  ;

  final IconData data;

  const CommunityMaterialIconsEnumMapper(this.data);
}
