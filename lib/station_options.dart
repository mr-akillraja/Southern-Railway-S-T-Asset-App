// stations.dart
class Stations {
  static List<String> getStations(String selectedSection) {
    switch (selectedSection) {
      case 'MAS':
        return [
          'Select Option',
          'MAS',
          'MASS',
        ];
      case 'BBQ':
        return [
          'Select Option',
          'BBQ',
          'KOK',
          'WST-VPY',
          'RPM',
          'VPY-KOK',
          'BBQ-VPY',
          'VPY',
          'VPY-VLK',
          'PEW',
          'PEW-VLK',
          'VLK',
          'VLK-ABU',
          'ABU',
          'ABU-AVD',
        ];
      case 'TVT':
        return [
          'Select Option',
          'KOK-TNP',
          'TNP',
          'TNP-TVT',
          'TVT',
          'TVT-ENR',
          'ENR',
          'ENR-AIPP',
          'AIPP',
          'AIP',
          'TNPM'
        ];
      case 'GPD':
        return [
          'AIP-MJR',
          'MJR',
          'MJR-PON',
          'PON',
          'PON-KVP',
          'KVP',
          'KVP-GPD',
          'GPD',
        ];
      case 'SPE':
        return [
          'GPD-ELR',
          'ELR',
          'ELR-AKM',
          'AKM',
          'AKM-TADA',
          'TADA',
          'TADA-SPE',
          'SPE',
          'SPE-PEL',
          'PEL'
        ];
      case 'NYP':
        return [
          'PEL-DVR',
          'DVR',
          'DVR-NYP',
          'NYP',
          'NYP-PYA',
          'PYA',
          'PYA-ODR',
          'ODR',
          'ODR-GDR',
        ];
      case 'TRL':
        return [
          'AVD',
          'AVD-PAB',
          'PAB',
          'PTMS',
          'E DEPOT',
          'PAB-TI',
          'TI',
          'TI-TRL',
          'TRL',
        ];
      case 'AJJE':
        return ['TRL-KBT', 'KBT', 'KBT-TO', 'TO', 'TO-AJJ', 'AJJ'];
      case 'AJJW (Arakkonam West)':
        return [
          'AJJN',
          'MLPM',
          'MLPM-CTRE',
          'CTRE',
          'CTRE-MDVE',
          'MDVE',
          'MDVE-SHU',
          'SHU'
        ];
      case 'TRT':
        return [
          'AJJN-TRT',
          'IPT',
          'TRT',
          'TRT-POI',
          'POI',
          'POI-NG',
          'NG',
          'NG-VGA',
          'VGA',
          'VGA-PUT',
          'PUT',
          'PUT-TDK',
          'TDK',
          'TDK-SVF',
          'SVF-PUDI',
          'TDK-PUDI',
          'PUDI',
          'PUDI-RU',
          'SVF'
        ];
      case 'KPDE':
        return [
          'SHU-TUG',
          'TUG',
          'TUG-WJR',
          'WJR',
          'WJR-MCN',
          'MCN',
          'MCN-THL',
          'THL',
          'THL-SVUR',
          'SVUR',
          'SVUR-KPD',
          'KPD',
        ];
      case 'KPDW':
        return [
          'KPD-LTI',
          'LTI',
          'LTI-KVN',
          'KVN',
          'KVN-GYM',
          'GYM',
          'GYM-VLT',
          'VLT',
          'VLT-MPI',
          'MPI',
          'MPI-PCKM',
          'PCKM'
        ];
      case 'AB':
        return [
          'PCKM-AB',
          'AB',
          'AB-VGM',
          'VGM',
          'VGM-VN',
          'VN',
          'VN-KDY',
          'KDY',
          'KDY-JTJ'
        ];
      case 'JTJ':
        return [
          'JTJ',
          'JTJ AUX',
        ];
      case 'MSB':
        return [
          'MSB',
          'MSB-RPM',
          'MSB-MS',
          'MSB-MPK',
          'MPK',
          'MSB-MCPK',
          'MCPK',
          'MCPK-MTMY',
          'MTMY',
          'MTMY-VLCY',
          'VLCY'
        ];
      case 'MS':
        return [
          'MS',
          'MS-MKK',
          'MKK',
          'MKK-STM',
          'STM',
          'STM-PV',
          'PV',
          'PV-CMP',
        ];
      case 'TBM':
        return [
          'CMP-TBM',
          'PV-TBM',
          'TBM',
          'TBM-VDR',
          'VDR',
          'VDR-GI',
          'TBM-GI',
          'GI',
          'GI-CTM',
          'CTM',
          'CTM-SKL',
          'GI-SKL',
          'SKL'
        ];
      case 'CGL':
        return [
          'SKL-CGL',
          'CGL',
          'CGL-OV',
          'OV',
          'OV-KGZ',
          'PTM',
          'KGZ',
          'KGZ-MMK',
          'MMK',
          'CGL-PALR',
          'PALR',
          'PALR-WJ',
          'WJ',
          'WJ-CJ',
          'CJ',
          'CJ-TMLP',
          'TMLP',
          'TMLP-MLPM',
        ];
      case 'TMV':
        return [
          'MMK-MLMR',
          'PQM',
          'MLMR',
          'MLMR-TZD',
          'TZD',
          'TZD-OLA',
          'OLA',
          'OLA-TMV',
          'PCLM',
          'TMV',
          'TMV-MTL',
          'MTL',
          'MTL-PEI',
          'PEI',
          'PEI-VVN',
          'VVN',
          'VVN-MYP',
          'MYP',
          'MYP-VM',
        ];
      // Add other cases for stations here...
      default:
        return ['Select Option'];
    }
  }
}
