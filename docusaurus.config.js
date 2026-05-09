// @ts-check
import { themes as prismThemes } from 'prism-react-renderer';

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Port',
  tagline: 'Documents Made Simple. Applications Built Fast',
  favicon: 'img/logo.ico',

  url: 'https://portdic.com',
  baseUrl: '/',

  organizationName: 'port',
  projectName: 'portdoc',

  onBrokenLinks: 'warn',

  future: {
    faster: true,
    v4: true,
  },

  markdown: {
    format: 'detect',
    hooks: {
      onBrokenMarkdownLinks: 'warn',
    },
  },

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: './sidebars.js',
          routeBasePath: '/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        title: 'Port',
        logo: {
          alt: 'Port Logo',
          src: 'img/logo.ico',
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'mainSidebar',
            position: 'left',
            label: 'Docs',
          },
          {
            href: 'https://marketplace.visualstudio.com/items?itemName=portroconn.portdic',
            label: 'VSCode Extension',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [],
      },
      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
        additionalLanguages: ['csharp', 'rust', 'go', 'bash', 'yaml', 'toml'],
      },
      colorMode: {
        defaultMode: 'dark',
        disableSwitch: false,
        respectPrefersColorScheme: true,
      },
    }),
};

export default config;
