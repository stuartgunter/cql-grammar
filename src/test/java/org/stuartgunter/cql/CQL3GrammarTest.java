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
import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(Parameterized.class)
public class CQL3GrammarTest {

    private static final String GRAMMAR_NAME = "CQL3";

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
                "truncate",
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
        final String grammarClassPrefix = String.format("org.stuartgunter.cql.%s", GRAMMAR_NAME);
        final String lexerClassName = String.format("%sLexer", grammarClassPrefix);
        final String parserClassName = String.format("%sParser", grammarClassPrefix);

        final ClassLoader classLoader = this.getClass().getClassLoader();
        final Class<? extends Lexer> lexerClass = classLoader.loadClass(lexerClassName).asSubclass(Lexer.class);
        final Class<? extends Parser> parserClass = classLoader.loadClass(parserClassName).asSubclass(Parser.class);

        final Constructor<? extends Lexer> lexerConstructor = lexerClass.getConstructor(CharStream.class);
        final Constructor<? extends Parser> parserConstructor = parserClass.getConstructor(TokenStream.class);

        ANTLRFileStream antlrFileStream = new ANTLRFileStream(inputFile.getAbsolutePath(), "UTF-8");
        Lexer lexer = lexerConstructor.newInstance(antlrFileStream);
        final CommonTokenStream tokens = new CommonTokenStream(lexer);

        Parser parser = parserConstructor.newInstance(tokens);
        parser.setErrorHandler(new BailErrorStrategy());
        final Method method = parserClass.getMethod("statements");
        ParserRuleContext parserRuleContext = (ParserRuleContext) method.invoke(parser);

        final String lispTree = Trees.toStringTree(parserRuleContext, parser);
        final String expectedTree = new String(Files.readAllBytes(expectationFile.toPath()));
        assertThat(lispTree).isEqualTo(expectedTree);
    }
}
