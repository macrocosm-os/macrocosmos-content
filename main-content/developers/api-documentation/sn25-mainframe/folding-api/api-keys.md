# API Keys

### Authentication <a href="#authentication" id="authentication"></a>

The API uses an API key authentication system. Clients must include the `X-API-Key` header with every request.

<figure><img src="../../../../.gitbook/assets/Screenshot 2025-05-02 at 07.52.49.png" alt=""><figcaption></figcaption></figure>



1. Clone the Repository

```bash
git clone https://github.com/macrocosm-os/folding.git
cd folding
```

2. Access API keys stored in a JSON file (`api_keys.json`)&#x20;
3. Each key has an owner and rate limit&#x20;
4. Admin API keys can manage other keys
5. Rate limiting enforced per API key
