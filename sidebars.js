/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  mainSidebar: [
    'index',
    {
      type: 'category',
      label: 'Quick Start',
      collapsed: false,
      items: [
        'quick',
      ],
    },
    {
      type: 'category',
      label: 'Documentation',
      collapsed: false,
      items: [
        'attribute',
        'package',
        'flow',
        'scheduler',
        'session',
        'entity',
        'tdb',
      ],
    },
    {
      type: 'category',
      label: 'Protocols',
      collapsed: false,
      items: [
        'tcp',
        'serial',
        'ftp',
        'filesender',
        'secs',
        'mqtt',
        'rtsp',
      ],
    },
    'library',
    {
      type: 'category',
      label: 'More',
      items: [
        'commands',
        'remote',
        'timesync',
        'license',
      ],
    },
  ],
};

export default sidebars;
