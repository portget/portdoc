/** @type {import('@docusaurus/plugin-content-docs').SidebarsConfig} */
const sidebars = {
  mainSidebar: [
    'index',
    'quick',
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
    {
      type: 'category',
      label: 'More',
      items: [
        'commands',
        'remote',
        'license',
      ],
    },
  ],
};

export default sidebars;
