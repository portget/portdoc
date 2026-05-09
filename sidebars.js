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
        'commands',
        'remote',
        'dotnet',
        'react',
        'sdk',
        'package',
        'portdic',
      ],
    },
    {
      type: 'category',
      label: 'Protocols',
      collapsed: false,
      items: [
        'opcua',
        'modbus',
        'ethernetip',
        'secs',
        'rtsp',
        'mqtt',
      ],
    },
    {
      type: 'category',
      label: 'More',
      items: [
        'learn',
        'frame',
        'reference',
        'supported',
        'license',
      ],
    },
  ],
};

export default sidebars;
