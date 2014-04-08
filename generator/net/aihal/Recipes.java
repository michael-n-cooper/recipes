package net.aihal;

import java.io.*;
import java.util.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;
import org.apache.commons.lang.*;
import org.apache.xerces.jaxp.*;
import org.apache.xml.resolver.tools.*;
import org.w3c.dom.*;

public class Recipes {

	private File dir;
	private File outDir;
	private String manifestPath;
	private String navigationPath;
	private String stringsPath;
	private String indexPath;
	private String templatePath;
	private String cuisinesDir;
	private String dishtypesDir;
	private String mainingredientsDir;
	private String occasionsDir;
	private String prefix;
	private String titleSuffix;
	private String[] files;
	private TreeMap<String, TreeSet> dishtypes;
	private TreeMap<String, TreeSet> cuisines;
	private TreeMap<String, TreeSet> mainingredients;
	private TreeMap<String, TreeSet> occasions;
	private TreeMap<String, String> recipes;
	private Document manifestDoc;
	private Document navigationDoc;
	private Document stringsDoc;
	private Document indexDoc;
	private Document templateDoc;
	private Document cuisinesDoc;
	private Document dishtypesDoc;
	private Document mainingredientsDoc;
	private Document occasionsDoc;
	private StringBuffer outtext;
	private StringBuffer stringtext;
	private File outfile;
	private FileWriter writer;
	private DocumentBuilderFactory dbf;
	private DocumentBuilder db;
	private DOMImplementation dim;
	private TransformerFactory tf;
	private Templates tp;

	public Recipes(String directory, String xslt) {
		this.dir = new File(directory);
		if (!dir.isDirectory()) System.out.println("Not a directory: + directory");
		this.outDir = new File(dir, "output/source/recipes/");
		this.manifestPath = "generate/manifest_recipes.xml";
		this.navigationPath = "generate/navigation_recipes.xml";
		this.stringsPath = "generate/strings_recipes.xml";
		this.indexPath = "index.en.xhtml";
		this.templatePath = "template.xhtml";
		this.cuisinesDir = "categories/cuisine/";
		this.dishtypesDir = "categories/dishtype/";
		this.mainingredientsDir = "categories/mainingredient/";
		this.occasionsDir = "categories/occasion/";
		this.prefix = "recipe_";
		this.titleSuffix = " - Recipes - Michael Cooper";
		this.dishtypes = new TreeMap<String, TreeSet>();
		this.cuisines = new TreeMap<String, TreeSet>();
		this.mainingredients = new TreeMap<String, TreeSet>();
		this.occasions = new TreeMap<String, TreeSet>();
		this.recipes = new TreeMap<String, String>();
		try {
			this.dbf = javax.xml.parsers.DocumentBuilderFactory.newInstance();
			dbf.setNamespaceAware(true);
			dbf.setValidating(false);
			this.db = dbf.newDocumentBuilder();
			db.setEntityResolver(new CatalogResolver());
			dim = db.getDOMImplementation();
			this. tf = TransformerFactory.newInstance();
		}
		catch (Exception e) {
			System.out.println("Unable to build transformer");
			System.out.println(e);
			e.printStackTrace();
			System.exit(0);
		}
		try {
			tp = tf.newTemplates(new StreamSource(new File(xslt)));
			manifestDoc = dim.createDocument(null, "manifest", null);
			navigationDoc = dim.createDocument(null, "navigation", null);
			stringsDoc = dim.createDocument(null, "strings", null);
			templateDoc = db.parse(new File(dir, templatePath));
			indexDoc = db.parse(new File(dir, indexPath));
			cuisinesDoc = db.parse(new File(dir, cuisinesDir + "index.en.xhtml"));
			dishtypesDoc = db.parse(new File(dir, dishtypesDir + "index.en.xhtml"));
			mainingredientsDoc = db.parse(new File(dir, mainingredientsDir + "index.en.xhtml"));
			occasionsDoc = db.parse(new File(dir, occasionsDir + "index.en.xhtml"));
		}
		catch (Exception e) {
			System.out.println("Problem parsing core documents");
			System.out.println(e);
			e.printStackTrace();
			System.exit(0);
		}
	}

	public static void main(String[] args) {
		if (args.length != 1) usage();
		String directory = "../source";
		String xslt = args[0];
		Recipes recipes = new Recipes(directory, xslt);
		try {
			recipes.process();
		}
		catch (java.io.IOException ioe) {
			System.out.println(ioe);
			ioe.printStackTrace();
		}
		catch (javax.xml.parsers.ParserConfigurationException pce) {
			System.out.println(pce);
			pce.printStackTrace();
		}
		catch (javax.xml.transform.TransformerConfigurationException tce) {
			System.out.println(tce);
			tce.printStackTrace();
		}
		catch (javax.xml.transform.TransformerException te) {
			System.out.println(te);
			te.printStackTrace();
		}
		catch (org.xml.sax.SAXException se) {
			System.out.println(se);
			se.printStackTrace();
		}
	}
	private static void usage() {
		System.out.println("Usage: java Recipes <xsltpath>");
		System.exit(0);
	}
	private void process() throws java.io.IOException, javax.xml.parsers.ParserConfigurationException, javax.xml.transform.TransformerConfigurationException, javax.xml.transform.TransformerException, org.xml.sax.SAXException {
		String curXML;
		String curNodeVal;
		StringTokenizer tokens;
		String curFileName;
		String curKey;
		String curVal;
		TreeSet<String> list;
		Document curDoc;
		NodeList nl;
		Node curNode;
		Element curElement;
		Element curListElement;
		Element curListElement2;
		Transformer t ;
		File outFile;
		Set keys;

		files = dir.list();
		for (int i = 0; i < files.length; i++) {
			curXML = files[i];
			if (curXML.endsWith(".xml")) {
				curDoc = db.parse(new File(dir, curXML));
				tokens = new StringTokenizer(curXML, ".");
				curFileName = tokens.nextToken();
				recipes.put(curFileName, curDoc.getElementsByTagName("title").item(0).getTextContent());

				// index dishtypes
				nl = curDoc.getElementsByTagName("dishtype");
				for (int j = 0; j < nl.getLength(); j++) {
					curNodeVal = nl.item(j).getTextContent();
					list = (TreeSet<String>)dishtypes.get(curNodeVal);
					if (list == null) {
						list = new TreeSet<String>();
						dishtypes.put(curNodeVal, list);
					}
					list.add(curFileName);
				}

				// index cuisines
				nl = curDoc.getElementsByTagName("cuisine");
				for (int j = 0; j < nl.getLength(); j++) {
				curNodeVal = nl.item(j).getTextContent();
					list = (TreeSet<String>)cuisines.get(curNodeVal);
					if (list == null) {
						list = new TreeSet<String>();
						cuisines.put(curNodeVal, list);
					}
					list.add(curFileName);
				}

				// index occasions
				nl = curDoc.getElementsByTagName("occasion");
				for (int j = 0; j < nl.getLength(); j++) {
				curNodeVal = nl.item(j).getTextContent();
					list = (TreeSet<String>)occasions.get(curNodeVal);
					if (list == null) {
						list = new TreeSet<String>();
						occasions.put(curNodeVal, list);
					}
					list.add(curFileName);
				}

				// index main ingredients
				nl = curDoc.getElementsByTagName("ingredient");
				for (int j = 0; j < nl.getLength(); j++) {
					curElement = (Element)nl.item(j);
					if (curElement.getAttribute("mainingredient").equals("true")) {
						curNodeVal = curElement.getElementsByTagName("item").item(0).getTextContent();
						list = (TreeSet<String>)mainingredients.get(curNodeVal);
						if (list == null) {
							list = new TreeSet<String>();
							mainingredients.put(curNodeVal, list);
						}
						list.add(curFileName);
					}
				}

				// transform the XML
				t = tp.newTransformer();
				t.transform(new DOMSource(curDoc), new StreamResult(new File(outDir, curFileName + ".en.xhtml")));
				
			}
		}

		// generate manifest and strings file
		
		
		curListElement = (Element)indexDoc.getElementsByTagName("body").item(0).appendChild(indexDoc.createElement("ul"));
		
		for (Iterator i = recipes.keySet().iterator(); i.hasNext(); ) {
			curKey = (String)i.next();
			curVal = recipes.get(curKey);
		
			StoreFileInfo(curKey, curVal);
		
			curElement = (Element)curListElement.appendChild(indexDoc.createElement("li"));
			curElement = (Element)curElement.appendChild(indexDoc.createElement("a"));
			curElement.setAttribute("href", "aihal:" + prefix + curKey);
			curElement.appendChild(indexDoc.createTextNode(curVal));
		}
		
		t = tf.newTransformer();
		t.setOutputProperty(OutputKeys.METHOD, "xml");
		t.transform(new DOMSource(indexDoc), new StreamResult(new File(outDir, indexPath)));

		//TODO: handle the index file so it shows up in meta files

		// generate cuisines, dishtypes, mainingredients, and occasions
		GenerateIndex("cuisine", cuisines, cuisinesDoc, cuisinesDir);
		GenerateIndex("dishtype", dishtypes, dishtypesDoc, dishtypesDir);
		GenerateIndex("mainingredient", mainingredients, mainingredientsDoc, mainingredientsDir);
		GenerateIndex("occasion", occasions, occasionsDoc, occasionsDir);
		
		//output the singular meta files
		t = tf.newTransformer();
		t.setOutputProperty(OutputKeys.METHOD, "xml");
		t.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "manifest.dtd");
		t.transform(new DOMSource(manifestDoc), new StreamResult(new File(outDir, manifestPath)));
		
		t = tf.newTransformer();
		t.setOutputProperty(OutputKeys.METHOD, "xml");
		t.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "navigation.dtd");
		t.transform(new DOMSource(navigationDoc), new StreamResult(new File(outDir, navigationPath)));

		t = tf.newTransformer();
		t.setOutputProperty(OutputKeys.METHOD, "xml");
		t.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, "strings.dtd");
		t.transform(new DOMSource(stringsDoc), new StreamResult(new File(outDir, stringsPath)));
	}

	private void GenerateIndex(String type, TreeMap<String, TreeSet> map, Document maindoc, String subdir) throws javax.xml.transform.TransformerConfigurationException, javax.xml.transform.TransformerException {
		Element curMainListElement;
		Element curSubListElement;
		Element curElement;
		String curKey;
		String curVal;
		String title;
		TreeSet<String> list;
		Transformer t;

		curMainListElement = (Element)maindoc.getElementsByTagName("body").item(0).appendChild(maindoc.createElement("ul"));

		StoreFileInfo("index", WordUtils.capitalizeFully(type + " index"), type);
		
		for (Iterator i = map.keySet().iterator(); i.hasNext(); ) {
			curKey = (String)i.next();
			list = (TreeSet<String>)map.get(curKey);
			title = WordUtils.capitalizeFully(curKey);
		
			// add reference to this item in the index file
			curElement = (Element)curMainListElement.appendChild(maindoc.createElement("li"));
			curElement = (Element)curElement.appendChild(maindoc.createElement("a"));
			curElement.setAttribute("href", "aihal:" + prefix + type + "_" + curKey.replaceAll("[\\s\\W]", "").toLowerCase());
			curElement.appendChild(maindoc.createTextNode(title));

			// store manifest and strings information for the file we're about to create
			StoreFileInfo(curKey.replaceAll("[\\s\\W]", "").toLowerCase(), title, type);
		
			// create and populate individual index file
			Document doc = db.newDocument();
			t = tf.newTransformer();
			t.transform(new DOMSource(templateDoc), new DOMResult(doc));
			doc.getElementsByTagName("title").item(0).appendChild(doc.createTextNode(title + titleSuffix));	
			doc.getElementsByTagName("h1").item(0).appendChild(doc.createTextNode(title));
			curSubListElement = (Element)doc.getElementsByTagName("body").item(0).appendChild(doc.createElement("ul"));
		
			for (Iterator j = list.iterator(); j.hasNext(); ) {
				curVal = (String)j.next();
				curElement = (Element)curSubListElement.appendChild(doc.createElement("li"));
				curElement = (Element)curElement.appendChild(doc.createElement("a"));
				curElement.setAttribute("href", "aihal:" + prefix + curVal);
				curElement.appendChild(doc.createTextNode(recipes.get(curVal)));
			}
		
			t = tf.newTransformer();
			t.setOutputProperty(OutputKeys.METHOD, "xml");
			t.transform(new DOMSource(doc), new StreamResult(new File(outDir, subdir + curKey.replaceAll("[\\s\\W]", "").toLowerCase() + ".en.xhtml")));
		}

		t = tf.newTransformer();
		t.setOutputProperty(OutputKeys.METHOD, "xml");
		t.transform(new DOMSource(maindoc), new StreamResult(new File(outDir, subdir + "index.en.xhtml")));
	}

	private void StoreFileInfo(String name, String label) {
		StoreFileInfo(name, label, null);
	}

	private void StoreFileInfo(String name, String label, String category) {
		Element curElement;
		Element starterElement = null;
		NodeList nl;
		String cat = category == null ? "" : category + "_";

		// Set manifest
		if (category == null) starterElement = manifestDoc.getDocumentElement();
		else {
			nl = manifestDoc.getElementsByTagName("folder");
			for (int i = 0; i < nl.getLength(); i++) {
				if (((Element)nl.item(i)).getAttribute("url").equals(category)) {
					starterElement = (Element)nl.item(i);
					break;
				}
			}
			if (starterElement == null) {
				starterElement = (Element)manifestDoc.getDocumentElement().appendChild(manifestDoc.createElement("folder"));
				starterElement.setAttribute("url", category.equals("index") ? "" : category);
				starterElement.setAttribute("path", category);
			}
		}

		curElement = (Element)starterElement.appendChild(manifestDoc.createElement("resource"));
		curElement.setAttribute("id", prefix + cat + name);
		curElement.setAttribute("url", name);
		curElement = (Element)curElement.appendChild(manifestDoc.createElement("file"));
		curElement.setAttribute("path", name + ".en.xhtml");
		curElement.setAttribute("lang", "en");
		curElement.setAttribute("type", "text/html");

		// Set navigation
		starterElement = null;
		if (category == null) starterElement = (Element)navigationDoc.getDocumentElement();
		else {
			nl = navigationDoc.getElementsByTagName("resourceref");
			for (int i = 0; i < nl.getLength(); i++) {
				if (((Element)nl.item(i)).getAttribute("ref").equals(prefix + cat + "index")) {
					starterElement = (Element)nl.item(i);
					break;
				}
			}
			if (starterElement == null) {
				starterElement = (Element)navigationDoc.getDocumentElement().appendChild(navigationDoc.createElement("resourceref"));
				starterElement.setAttribute("ref", prefix + cat + "index");
				starterElement.setAttribute("primarypath", "true");
				starterElement.setAttribute("display", "true");
				starterElement.setAttribute("elide", "false");
			}
		}

		curElement = (Element)starterElement.appendChild(navigationDoc.createElement("resourceref"));
		curElement.setAttribute("ref", prefix + cat +  name);
		curElement.setAttribute("display", "false");
		curElement.setAttribute("primarypath", "true");
		curElement.setAttribute("elide", "true");
		
		// Set strings
		curElement = (Element)stringsDoc.getDocumentElement().appendChild(stringsDoc.createElement("string"));
		curElement.setAttribute("ref", prefix + cat + name);
		curElement.appendChild(stringsDoc.createTextNode(label));
	}
}