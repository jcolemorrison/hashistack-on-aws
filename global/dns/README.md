Root module for the global infrastructure's DNS post all deployments across all sandboxes.  README pending.

After a sandbox/infrastructure space deploys, it will output name servers for it's subdomain.  Those are what are added here for DNS delegation so that each sandbox can manage its own subdomain.

When destroying all sandboxes, this one should be taken down first in order to avoid order of operations errors.