            "sharing": {
                "facebook": false,

                "google": false,

                "github": true,
              {% if site.github_username %}
                "github_link": "https://github.com/{{ site.github_username }}",
              {% else %}
                "github_link": "https://github.com",
              {% endif %}

                "linkedin": true,
              {% if site.linkedin_url %}
                "linkedin_link": "{{ site.linkedin_url }}",
              {% else %}
                "linkedin_link": "https://www.linkedin.com",
              {% endif %}

                "telegram": false,

                "instapaper": false,

                "twitter": false,

                "vk": false,

                "weibo": false,

                "all": []
            },
