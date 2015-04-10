package eu.learnpad;

import java.io.File;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

/**
 * A simple demo of JAXP 1.1
 */
public class XSLTTransformer {

	/**
	 * Accept two command line arguments: the name of an XML file, and the name
	 * of an XSLT stylesheet. The result of the transformation is written to
	 * stdout.
	 */
	public static void main(String[] args) throws TransformerException {
		if (args.length != 2) {
			System.err.println("Usage:");
			System.err.println(" java " + XSLTTransformer.class.getName()
					+ " xmlFileName xsltFileName");
			System.exit(1);
		}

		File xmlFile = new File(args[0]);
		File xsltFile = new File(args[1]);

		Source xmlSource = new StreamSource(xmlFile);
		Source xsltSource = new StreamSource(xsltFile);
		Result result = new StreamResult(System.out);

		// create an instance of TransformerFactory
		TransformerFactory transFact = TransformerFactory.newInstance();

		javax.xml.transform.Transformer trans = transFact
				.newTransformer(xsltSource);

		trans.transform(xmlSource, result);
	}
}
