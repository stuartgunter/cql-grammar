package org.stuartgunter.cql;

import com.google.common.base.Function;
import com.google.common.collect.FluentIterable;
import com.google.common.collect.ImmutableSet;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.Trees;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(Parameterized.class)
public class CQL3GrammarTest {

    private static final String GRAMMAR_NAME = "CQL3";
    private static final String GRAMMAR_CLASS_PREFIX = String.format("org.stuartgunter.cql.%s", GRAMMAR_NAME);

    private final File inputFile;
    private final File expectationFile;

    public CQL3GrammarTest(String baseFilename) {
        this.inputFile = Paths.get("src/test/antlr4/", GRAMMAR_NAME, String.format("%s.cql", baseFilename)).toFile();
        this.expectationFile = Paths.get("src/test/antlr4/", GRAMMAR_NAME, String.format("%s.parseTree", baseFilename)).toFile();
    }

    @Parameterized.Parameters(name = "{0}")
    public static Collection<Object[]> data() throws IOException {
        final Set<String> testCases = ImmutableSet.of(
                "alter-keyspace",
                "alter-table",
                "create-index",
                "create-table",
                "drop-index",
                "drop-keyspace",
                "drop-table",
                "insert",
                "truncate",
                "update",
                "use");

        return FluentIterable
                .from(testCases)
                .transform(new Function<String, Object[]>() {
                    @Override
                    public Object[] apply(String testCase) {
                        return new Object[] { testCase };
                    }
                })
                .toList();
    }

    @Test
    public void testGrammar() throws Exception {
        final String lexerClassName = String.format("%sLexer", GRAMMAR_CLASS_PREFIX);
        final String parserClassName = String.format("%sParser", GRAMMAR_CLASS_PREFIX);

        final Class<? extends Lexer> lexerClass = Class.forName(lexerClassName).asSubclass(Lexer.class);
        final Class<? extends Parser> parserClass = Class.forName(parserClassName).asSubclass(Parser.class);

        final Constructor<? extends Lexer> lexerConstructor = lexerClass.getConstructor(CharStream.class);
        final Constructor<? extends Parser> parserConstructor = parserClass.getConstructor(TokenStream.class);

        final ANTLRFileStream antlrFileStream = new ANTLRFileStream(inputFile.getAbsolutePath(), "UTF-8");
        final Lexer lexer = lexerConstructor.newInstance(antlrFileStream);
        final CommonTokenStream tokens = new CommonTokenStream(lexer);
        final Parser parser = parserConstructor.newInstance(tokens);
        parser.setErrorHandler(new BailErrorStrategy());
        final Method method = parserClass.getMethod("statements");
        final ParserRuleContext parserRuleContext = (ParserRuleContext) method.invoke(parser);

        final String actualParseTree = Trees.toStringTree(parserRuleContext, parser);
        final String expectedParseTree = new String(Files.readAllBytes(expectationFile.toPath()));

        assertThat(actualParseTree).isEqualTo(expectedParseTree);
    }
}
