# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type-aware lint rules:

```js
export default tseslint.config([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...

      // Remove tseslint.configs.recommended and replace with this
      ...tseslint.configs.recommendedTypeChecked,
      // Alternatively, use this for stricter rules
      ...tseslint.configs.strictTypeChecked,
      // Optionally, add this for stylistic rules
      ...tseslint.configs.stylisticTypeChecked,

      // Other configs...
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```

You can also install [eslint-plugin-react-x](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-x) and [eslint-plugin-react-dom](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-dom) for React-specific lint rules:

```js
// eslint.config.js
import reactX from 'eslint-plugin-react-x'
import reactDom from 'eslint-plugin-react-dom'

export default tseslint.config([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...
      // Enable lint rules for React
      reactX.configs['recommended-typescript'],
      // Enable lint rules for React DOM
      reactDom.configs.recommended,
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```

## Deploy to S3

- Build locally: `npm run build`
- Set env vars:
  - `AWS_REGION`: AWS region (e.g., `us-east-1`)
  - `S3_BUCKET`: Target S3 bucket name
  - optional `CACHE_MAX_AGE_SECONDS`: default `86400`
- Deploy: `npm run deploy:s3`

The deploy script `scripts/deploy-s3.sh` will sync `dist/` to S3 with cache headers. HTML files are uploaded with `no-cache`.

## Jenkins Pipeline

This repo includes a `Jenkinsfile` that:
- Installs dependencies
- Builds the app
- Archives the `dist/`
- Deploys to S3 on `main` or `master`

Configure these Jenkins credentials (Kind: Secret text unless noted):
- `aws-default-region`: e.g., `us-east-1`
- `aws-access-key-id` (Kind: Username with password OR Secret text)
- `aws-secret-access-key` (Kind: Secret text or password)
- `s3-static-site-bucket`: S3 bucket name

Ensure the Jenkins agent has AWS CLI v2 installed. The deploy step runs:
```
AWS_REGION=$AWS_DEFAULT_REGION S3_BUCKET=$S3_BUCKET npm run deploy:s3
```

### S3 static website hosting
- Enable static website hosting on the bucket or serve behind CloudFront.
- If hosting at a subpath, set `base` in `vite.config.ts` accordingly.
# s3BucketWithCicd
