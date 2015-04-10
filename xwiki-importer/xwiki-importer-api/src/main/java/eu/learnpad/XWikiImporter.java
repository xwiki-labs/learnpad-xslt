package eu.learnpad;

import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.QueryParam;

import org.xwiki.rest.XWikiRestException;

@Path("/learnpad/wiki")
public interface XWikiImporter {
	@PUT
	void importWiki(@QueryParam("path") String path) throws XWikiRestException;
}
